#
# Cookbook Name:: cloudpassage-halo
# Recipe:: default
#
# Copyright 2015, CloudPassage

::Chef::Recipe.send(:include, Windows::Helper)

begin
  node.set['cloudpassage_halo']['secrets'] = (
    Chef::EncryptedDataBagItem.load('credentials', 'halo'))
  Chef::Log.info('Loaded data bag')
  node.set['cloudpassage_halo']['agent_key'] = (
    node['cloudpassage_halo']['secrets']['agent_key'])
  Chef::Log.info('Loaded agent_key from data bag')
  node.set['cloudpassage_halo']['proxy_user'] = (
    node['cloudpassage_halo']['secrets']['proxy_user'])
  Chef::Log.info('Loaded proxy_user from data bag')
  node.set['cloudpassage_halo']['proxy_password'] = (
    node['cloudpassage_halo']['secrets']['proxy_password'])
  Chef::Log.warn('Loaded proxy_password from data bag')
rescue
  Chef::Log.warn('Unable to completely load data bag and attributes!')
end

config = node['cloudpassage_halo']

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
    not_if config['apt_repo_url'] == ''
    action :add
  end
when 'rhel'
  yum_repository 'cloudpassage' do
    description 'CloudPassage Halo Repository'
    baseurl config['yum_repo_url']
    gpgkey config['yum_key_url']
    action :create
    not_if config['yum_repo_url'] == ''
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
    not_if 'test -e /opt/cloudpassage/data/store.db'
  end
  service 'cphalod' do
    supports [:start, :stop, :restart]
    start_command '/etc/init.d/cphalod start'
    stop_command '/etc/init.d/cphalod stop'
    restart_command '/etc/init.d/cphalod restart'
    action :start
  end
when 'windows'
  win_start_options = configurator.windows_configuration
  # If the Halo agent is already installed, assume upgrade and
  # don't re-register with agent key, etc.

  # Get Chef people's advice on writing chefspec tests for this-
  # Ruby doesn't load the Win32 libraries on non-Windows platforms,
  # and thusly bombs out when tested on non-Win platforms.
  # win_start_options = '/S' if is_package_installed?('CloudPassage Halo')

  windows_package 'CloudPassage Halo' do
    source configurator.windows_installation_path
    options win_start_options
    installer_type :custom
    action :install
  end
  service 'cphalo' do
    action [:enable, :start]
  end
end
