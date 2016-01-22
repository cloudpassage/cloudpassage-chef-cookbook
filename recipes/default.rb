#
# Cookbook Name:: cloudpassage
# Recipe:: default
#
# Copyright 2016, CloudPassage

include_recipe 'apt' if node['platform_family'] == 'debian'
include_recipe 'yum' if node['platform_family'] == 'rhel'

begin
  node.set['cloudpassage']['bagged'] = data_bag('cloudpassage')
  Chef::Log.info('Loaded data bag')
  node.set['cloudpassage']['agent_key'] = node['cloudpassage']['bagged']['agent_key']
  Chef::Log.info('Loaded agent_key from data bag')
  node.set['cloudpassage']['proxy_user'] = node['cloudpassage']['bagged']['proxy_user']
  Chef::Log.info('Loaded proxy_user from data bag')
  node.set['cloudpassage']['proxy_password'] = node['cloudpassage']['bagged']['proxy_password']
  Chef::Log.info('Loaded proxy_password from data bag')
rescue
  Chef::Log.warn('Unable to completely load data bag and attributes!')
end

begin
  node.set['cloudpassage']['secrets'] = Chef::EncryptedDataBagItem.load('credentials', 'halo')
  Chef::Log.info('Loaded encrypted data bag')
  node.set['cloudpassage']['agent_key'] = node['cloudpassage']['secrets']['agent_key']
  Chef::Log.info('Loaded agent_key from encrypted data bag')
  node.set['cloudpassage']['proxy_user'] = node['cloudpassage']['secrets']['proxy_user']
  Chef::Log.info('Loaded proxy_user from encrypted data bag')
  node.set['cloudpassage']['proxy_password'] = node['cloudpassage']['secrets']['proxy_password']
  Chef::Log.info('Loaded proxy_password from encrypted data bag')
rescue
  Chef::Log.warn('Unable to completely load encrypted data bag and attributes!')
end

config = node['cloudpassage']

configurator = CloudPassage::ConfigHelper.new(
  config['agent_key'],
  grid_url: config['grid_url'], proxy_host: config['proxy_host'],
  proxy_port: config['proxy_port'], read_only: config['read_only'],
  server_tag: config['server_tag'], server_label: config['server_label'],
  proxy_user: config['proxy_user'], proxy_password: config['proxy_password'],
  windows_installer_protocol: config['windows_installer_protocol'],
  windows_installer_host: config['windows_installer_host'],
  windows_installer_port: config['windows_installer_port'],
  windows_installer_path: config['windows_installer_path'],
  windows_installer_file_name: config['windows_installer_file_name'])

# Set up repositories for Linux
case node['platform_family']
when 'debian'
  apt_repository 'cloudpassage' do
    uri config['apt_repo_url']
    distribution config['apt_repo_distribution']
    components config['apt_repo_components']
    key config['apt_key_url']
    not_if config['apt_repo_url'] == '' || config['apt_repo_url'].nil?
    action :add
  end
when 'rhel'
  yum_repository 'cloudpassage' do
    description 'CloudPassage Halo Repository'
    baseurl config['yum_repo_url']
    gpgkey config['yum_key_url']
    action :create
    not_if config['yum_repo_url'] == '' || config['yum_repo_url'].nil?
  end
end
# Install and register the Halo agent
case node['platform_family']
when 'debian', 'rhel'
  package 'cphalo' do
    action :upgrade
  end
  execute 'cphalo-config' do
    command [
      '/opt/cloudpassage/bin/configure',
      configurator.linux_configuration].join(' ')
    action :run
    # We don't run the configurator if the store.db file already exists
    not_if { ::File.exist?('/opt/cloudpassage/data/store.db') }
  end
  service 'CloudPassage Halo Agent for Linux' do
    service_name 'cphalod'
    # Force systemd for RHEL 7+.
    if node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 7
      provider Chef::Provider::Service::Systemd
    end
    supports [:start, :stop, :restart]
    action [:restart]
  end
when 'windows'
  win_installer_version = config['windows_installer_file_name']
                          .gsub(/.*cphalo-(\d*\.\d*\.\d*)-win64.exe/, '\1')
  win_start_options = configurator.windows_configuration
  progfiles = ENV['PROGRAMW6432']
  Chef::Log.info("Detected ProgramFiles directory: #{progfiles}")
  win_start_options = '/S' if ::File.exist?("#{progfiles}\\CloudPassage\\data\\store.db")
  windows_package 'CloudPassage Halo' do
    source configurator.windows_installation_path
    options win_start_options
    version win_installer_version
    installer_type :custom
    action :install
  end
  service 'CloudPassage Halo Agent for Windows' do
    service_name 'cphalo'
    action [:enable, :start]
  end
end
