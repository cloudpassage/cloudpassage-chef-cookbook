#
# Cookbook Name:: cloudpassage
# Recipe:: default
#
# Copyright 2016, CloudPassage

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

# Merge configs- final authority is the encrypted data bag
final_config = config.merge(dbconfig).merge(edbconfig)

cloudpassage_agent 'halo' do
  agent_key final_config['agent_key']
  linux_agent_version final_config['linux_agent_version']
  grid_url final_config['grid_url']
  azure_id final_config['azure_id']
  proxy_host final_config['proxy_host']
  proxy_port final_config['proxy_port']
  proxy_user final_config['proxy_user']
  proxy_password final_config['proxy_password']
  read_only final_config['read_only']
  server_tag final_config['server_tag']
  server_label final_config['server_label']
  dns final_config['dns']
  windows_installer_protocol final_config['windows_installer_protocol']
  windows_installer_port final_config['windows_installer_port']
  windows_installer_host final_config['windows_installer_host']
  windows_installer_path final_config['windows_installer_path']
  windows_installer_file_name final_config['windows_installer_file_name']
  apt_repo_url final_config['apt_repo_url']
  apt_repo_distribution final_config['apt_repo_distribution']
  apt_repo_components final_config['apt_repo_components']
  yum_repo_url final_config['yum_repo_url']
  apt_key_url final_config['apt_key_url']
  yum_key_url final_config['yum_key_url']
  action :install
end
