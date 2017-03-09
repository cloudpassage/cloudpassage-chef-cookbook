default['cloudpassage']['agent_key'] = 'abc123'
default['cloudpassage']['grid_url'] = 'https://grid.cloudpassage.com/grid'
default['cloudpassage']['linux_agent_version'] = '3.9.5'
# If you define a proxy host, you must also define the port!
default['cloudpassage']['proxy_host'] = nil
default['cloudpassage']['proxy_port'] = nil
default['cloudpassage']['proxy_user'] = nil
default['cloudpassage']['proxy_password'] = nil
default['cloudpassage']['read_only'] = false
default['cloudpassage']['server_tag'] = nil
default['cloudpassage']['server_label'] = nil
default['cloudpassage']['dns'] = true
default['cloudpassage']['windows_installer_protocol'] = 'https'
default['cloudpassage']['windows_installer_port'] = '443'
default['cloudpassage']['windows_installer_host'] = 'production.packages.cloudpassage.com'
default['cloudpassage']['windows_installer_path'] = '/windows/'
default['cloudpassage']['windows_installer_file_name'] = 'cphalo-3.9.7-win64.exe'
default['cloudpassage']['apt_repo_url'] = 'http://production.packages.cloudpassage.com/debian'
default['cloudpassage']['apt_repo_distribution'] = 'debian'
default['cloudpassage']['apt_repo_components'] = ['main']
default['cloudpassage']['yum_repo_url'] = 'http://production.packages.cloudpassage.com/redhat/$basearch'
default['cloudpassage']['apt_key_url'] = 'http://production.packages.cloudpassage.com/cloudpassage.packages.key'
default['cloudpassage']['yum_key_url'] = 'http://production.packages.cloudpassage.com/cloudpassage.packages.key'
