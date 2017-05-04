actions :install, :reconfigure, :remove
default_action :install
property :agent_key, [String, nil]
property :grid_url, String, default: 'https://grid.cloudpassage.com/grid'
property :linux_agent_version, [String, nil]
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
property :windows_installer_file_name, String, default: 'cphalo-4.0.0-win64.exe'
property :apt_repo_url, [String, nil], default: 'https://production.packages.cloudpassage.com/debian'
property :apt_repo_distribution, [String, nil], default: 'debian'
property :apt_repo_components, [String, Array, nil], default: ['main']
property :yum_repo_url, [String, nil], default: 'https://production.packages.cloudpassage.com/redhat/$basearch'
property :apt_key_url, [String, nil], default: 'https://production.packages.cloudpassage.com/cloudpassage.packages.key'
property :yum_key_url, [String, nil], default: 'https://production.packages.cloudpassage.com/cloudpassage.packages.key'

action :install do
  fail 'agent_key is not set, agent will not register without one!' if agent_key.nil?
  conf = { 'agent_key' => agent_key, 'grid_url' => grid_url, 'proxy_host' => proxy_host,
           'proxy_port' => proxy_port,
           'proxy_user' => proxy_user, 'proxy_password' => proxy_password, 'read_only' => read_only,
           'server_tag' => server_tag, 'server_label' => server_label, 'dns' => dns,
           'windows_installer_protocol' => windows_installer_protocol,
           'windows_installer_port' => windows_installer_port,
           'windows_installer_host' => windows_installer_host,
           'windows_installer_path' => windows_installer_path,
           'windows_installer_file_name' => windows_installer_file_name,
           'apt_repo_url' => apt_repo_url, 'apt_repo_distribution' => apt_repo_distribution,
           'apt_repo_components' => apt_repo_components, 'yum_repo_url' => yum_repo_url,
           'apt_key_url' => apt_key_url, 'yum_key_url' => yum_key_url }

  configurator = CloudPassage::ConfigHelper.new(conf)
  # First, set up repos
  case node['platform_family']
  when 'debian'
    apt_repository 'cloudpassage' do
      uri apt_repo_url
      distribution apt_repo_distribution
      components apt_repo_components
      key apt_key_url
      not_if apt_repo_url == '' || apt_repo_url.nil?
      action :add
    end
  when 'rhel', 'amazon'
    yum_repository 'cloudpassage' do
      description 'CloudPassage Halo Repository'
      baseurl yum_repo_url
      gpgkey yum_key_url
      action :create
      not_if yum_repo_url == '' || yum_repo_url.nil?
    end
  end
  # Now we install...
  case node['platform_family']
  when 'debian', 'rhel', 'amazon'
    package 'cphalo' do
      version linux_agent_version unless linux_agent_version.nil?
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
    win_installer_version = windows_installer_file_name.gsub(/.*cphalo-(\d*\.\d*\.\d*)-win64.exe/, '\1')
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
  conf = { 'agent_key' => agent_key, 'grid_url' => grid_url, 'proxy_host' => proxy_host,
           'proxy_port' => proxy_port,
           'proxy_user' => proxy_user, 'proxy_password' => proxy_password, 'read_only' => read_only,
           'server_tag' => server_tag, 'server_label' => server_label, 'dns' => dns,
           'windows_installer_protocol' => windows_installer_protocol,
           'windows_installer_port' => windows_installer_port,
           'windows_installer_host' => windows_installer_host,
           'windows_installer_path' => windows_installer_path,
           'windows_installer_file_name' => windows_installer_file_name,
           'apt_repo_url' => apt_repo_url, 'apt_repo_distribution' => apt_repo_distribution,
           'apt_repo_components' => apt_repo_components, 'yum_repo_url' => yum_repo_url,
           'apt_key_url' => apt_key_url, 'yum_key_url' => yum_key_url }

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
