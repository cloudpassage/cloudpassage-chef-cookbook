actions :install, :reconfigure, :remove
default_action :install
property :agent_key, [String, nil]
property :grid_url, String, default: 'https://grid.cloudpassage.com/grid'
property :linux_agent_version, [String, nil]
property :azure_id, [String, nil]
property :proxy_host, [String, nil]
property :proxy_port, [String, nil]
property :proxy_user, [String, nil]
property :proxy_password, [String, nil]
property :read_only, kind_of: [TrueClass, FalseClass], default: false
property :server_tag, [String, nil]
property :server_label, [String, nil]
property :dns, kind_of: [TrueClass, FalseClass], default: true
property :windows_installer_protocol, String, default: 'https'
property :windows_installer_port, String, default: '443'
property :windows_installer_host, String, default: 'production.packages.cloudpassage.com'
property :windows_installer_path, String, default: '/windows/'
property :windows_installer_file_name, String, default: 'cphalo-4.1.3-win64.exe'
property :apt_repo_url, [String, nil], default: 'https://production.packages.cloudpassage.com/debian'
property :apt_repo_distribution, [String, nil], default: 'debian'
property :apt_repo_components, [String, Array, nil], default: ['main']
property :yum_repo_url, [String, nil], default: 'https://production.packages.cloudpassage.com/redhat/$basearch'
property :apt_key_url, [String, nil], default: 'https://production.packages.cloudpassage.com/cloudpassage.packages.key'
property :yum_key_url, [String, nil], default: 'https://production.packages.cloudpassage.com/cloudpassage.packages.key'

action :install do
  fail 'agent_key is not set, agent will not register without one!' if new_resource.agent_key.nil?
  hostname = node['hostname']
  label =
    if new_resource.server_label.nil? && new_resource.azure_id
      "#{azure_id}_#{hostname}"
    elsif new_resource.server_label
      new_resource.server_label
    else
      nil
    end

  conf = {
    'agent_key' => new_resource.agent_key,
    'grid_url' => new_resource.grid_url,
    'proxy_host' => new_resource.proxy_host,
    'proxy_port' => new_resource.proxy_port,
    'proxy_user' => new_resource.proxy_user,
    'proxy_password' => new_resource.proxy_password,
    'read_only' => new_resource.read_only,
    'server_tag' => new_resource.server_tag,
    'server_label' => label,
    'dns' => new_resource.dns,
    'windows_installer_protocol' => new_resource.windows_installer_protocol,
    'windows_installer_port' => new_resource.windows_installer_port,
    'windows_installer_host' => new_resource.windows_installer_host,
    'windows_installer_path' => new_resource.windows_installer_path,
    'windows_installer_file_name' => new_resource.windows_installer_file_name,
    'apt_repo_url' => new_resource.apt_repo_url,
    'apt_repo_distribution' => new_resource.apt_repo_distribution,
    'apt_repo_components' => new_resource.apt_repo_components,
    'yum_repo_url' => new_resource.yum_repo_url,
    'apt_key_url' => new_resource.apt_key_url,
    'yum_key_url' => new_resource.yum_key_url
  }

  configurator = CloudPassage::ConfigHelper.new(conf)
  # First, set up repos
  case node['platform_family']
  when 'debian'
    apt_update 'update'
    apt_package 'apt-transport-https'

    apt_repository 'cloudpassage' do
      uri new_resource.apt_repo_url
      distribution new_resource.apt_repo_distribution
      components new_resource.apt_repo_components
      key new_resource.apt_key_url
      not_if new_resource.apt_repo_url == '' || new_resource.apt_repo_url.nil?
      action :add
    end
  when 'rhel', 'amazon'
    yum_repository 'cloudpassage' do
      description 'CloudPassage Halo Repository'
      baseurl new_resource.yum_repo_url
      gpgkey new_resource.yum_key_url
      action :create
      not_if new_resource.yum_repo_url == '' || new_resource.yum_repo_url.nil?
    end
  end
  # Now we install...
  case node['platform_family']
  when 'debian', 'rhel', 'amazon'
    package 'cphalo' do
      version new_resource.linux_agent_version unless new_resource.linux_agent_version.nil?
      notifies :start, 'service[CloudPassage Halo Agent for Linux]', :delayed
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
      if (%w(redhat centos).include? node['platform']) && node['platform_version'].to_f >= 7
        provider Chef::Provider::Service::Systemd
      end
      supports [:start, :stop, :restart]
      action [:nothing]
    end
  when 'windows'
    win_installer_version = new_resource.windows_installer_file_name.gsub(/.*cphalo-(\d*\.\d*\.\d*)-win64.exe/, '\1')
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
      notifies :start, 'service[CloudPassage Halo Agent for Windows]', :delayed
    end
    service 'CloudPassage Halo Agent for Windows' do
      service_name 'cphalo'
      action [:enable, :start]
    end
  end
end

action :reconfigure do
  fail 'agent_key is not set, keyless reconfigure is not supported!' if agent_key.nil?
  conf = {
    'agent_key' => new_resource.agent_key,
    'grid_url' => new_resource.grid_url,
    'proxy_host' => new_resource.proxy_host,
    'proxy_port' => new_resource.proxy_port,
    'proxy_user' => new_resource.proxy_user,
    'proxy_password' => new_resource.proxy_password,
    'read_only' => new_resource.read_only,
    'server_tag' => new_resource.server_tag,
    'server_label' => new_resource.server_label,
    'dns' => new_resource.dns,
    'windows_installer_protocol' => new_resource.windows_installer_protocol,
    'windows_installer_port' => new_resource.windows_installer_port,
    'windows_installer_host' => new_resource.windows_installer_host,
    'windows_installer_path' => new_resource.windows_installer_path,
    'windows_installer_file_name' => new_resource.windows_installer_file_name,
    'apt_repo_url' => new_resource.apt_repo_url,
    'apt_repo_distribution' => new_resource.apt_repo_distribution,
    'apt_repo_components' => new_resource.apt_repo_components,
    'yum_repo_url' => new_resource.yum_repo_url,
    'apt_key_url' => new_resource.apt_key_url,
    'yum_key_url' => new_resource.yum_key_url
  }

  reconfigurator = CloudPassage::ConfigHelper.new(conf)
  case node['platform_family']
  when 'debian', 'rhel', 'amazon'
    execute 'cphalo-config' do
      command [
        '/opt/cloudpassage/bin/configure',
        reconfigurator.linux_configuration].join(' ')
      action :run
      notifies :restart, 'service[CloudPassage Halo Agent for Linux]', :delayed
    end
    service 'CloudPassage Halo Agent for Linux' do
      service_name 'cphalod'
      # Force systemd for RHEL 7+.
      if (%w(redhat centos).include? node['platform']) && node['platform_version'].to_f >= 7
        provider Chef::Provider::Service::Systemd
      end
      supports [:start, :stop, :restart]
      action [:nothing]
    end
  when 'windows'
    win_reconfigure_options = reconfigurator.windows_reconfiguration
    service 'CloudPassage Halo Agent for Windows' do
      service_name 'cphalo'
      start_command "net start #{service_name} #{win_reconfigure_options}"
      action [:stop, :start]
    end
  end
end

action :remove do
  case node['platform_family']
  when 'debian', 'rhel', 'amazon'
    package 'cphalo' do
      action :remove
    end
  when 'windows'
    windows_package 'CloudPassage Halo' do
      source configurator.windows_installation_path
      options win_start_options
      version win_installer_version
      installer_type :custom
      action :remove
    end
  end
end
