#
# Cookbook Name:: cloudpassage
# Recipe:: default
#
# Copyright 2016, CloudPassage

include_recipe 'apt' if node['platform_family'] == 'debian'
include_recipe 'yum' if node['platform_family'] == 'rhel'

# Grab config from attributes file
config = node['cloudpassage']

# Attempt to load databag.  If it fails, set it to an empty hash.
begin
  dbconfig = data_bag('cloudpassage')
rescue
  dbconfig = {}
end

# Attempt to load encrypted databag.  If it fails, set it to an empty hash.
begin
  edbconfig = Chef::EncryptedDataBagItem.load('credentials', 'halo')
rescue
  edbconfig = {}
end

# Build a configurator object with all configs.  It'll sort out prescedence.
configurator = CloudPassage::ConfigHelper.new(base_config: config,
                                              databag_config: dbconfig,
                                              encrypted_databag_config: edbconfig)

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
