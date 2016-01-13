default['cloudpassage_halo']['agent_key'] = 'abc123'
default['cloudpassage_halo']['grid_url'] = 'https://grid.cloudpassage.com/grid'
# If you define a proxy host, you must also define the port!
default['cloudpassage_halo']['proxy_host'] = ''
default['cloudpassage_halo']['proxy_port'] = ''
default['cloudpassage_halo']['proxy_user'] = ''
default['cloudpassage_halo']['proxy_password'] = ''
default['cloudpassage_halo']['read_only'] = false
default['cloudpassage_halo']['server_tag'] = ''
default['cloudpassage_halo']['server_label'] = ''
default['cloudpassage_halo']['dns'] = true
default['cloudpassage_halo']['windows_installer_protocol'] = 'https'
default['cloudpassage_halo']['windows_installer_port'] = '443'
default['cloudpassage_halo']['windows_installer_host'] = (
  'packages.cloudpassage.com')
default['cloudpassage_halo']['windows_installer_path'] = '/windows/'
default['cloudpassage_halo']['windows_installer_file_name'] = (
  'cphalo-3.6.6-win64.exe')
default['cloudpassage_halo']['apt_repo_url'] = (
  'http://packages.cloudpassage.com/debian')
default['cloudpassage_halo']['apt_repo_distribution'] = 'debian'
default['cloudpassage_halo']['apt_repo_components'] = ['main']
default['cloudpassage_halo']['yum_repo_url'] = (
  'http://packages.cloudpassage.com/redhat/$basearch')
default['cloudpassage_halo']['apt_key_url'] = (
  'http://packages.cloudpassage.com/cloudpassage.packages.key')
default['cloudpassage_halo']['yum_key_url'] = (
  'http://packages.cloudpassage.com/cloudpassage.packages.key')
