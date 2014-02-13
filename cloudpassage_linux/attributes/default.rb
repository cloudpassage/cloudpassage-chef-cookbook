# Cookbook Name:: install_halo 
# Recipe:: default
# Author:: ehoffmann
#
# Copyright 2013, CloudPassage
#
# determine OS and relevant package_mgr cmds
# Changes by Ash:
#   Added various log points in the code
#   Changed the contents of check_halo_installed to be enclosed by backticks:
#     This allows us to set the variable once at runtime instead of multiple times throughout the script
#   Since we're exiting the recipe in the event Halo is already installed, we don't need the not_if clauses anymore.
#  
#  Tested working on Debian 7.1, Fedora 20, Ubuntu 13
#
case node[:platform]
  when "debian", "ubuntu"
    base_url = "http://packages.cloudpassage.com/debian debian main"
    repo_cmd = "echo 'deb #{base_url}' | sudo tee /etc/apt/sources.list.d/cloudpassage.list > /dev/null"
    key_cmd = "curl http://packages.cloudpassage.com/cloudpassage.packages.key | sudo apt-key add -"
    check_key_installed = "sudo apt-key list | grep -i cloudpassage"
    check_halo_installed = `sudo dpkg-query -W cphalo`
    Chef::Log.info('Detected DPKG-based OS')
    Chef::Log.info(check_halo_installed)
    update_repo_cmd = "sudo apt-get update"

  when "centos", "fedora", "rhel", "redhat", "amazon"
     base_url = "http://packages.cloudpassage.com/redhat/$basearch\ngpgcheck=1"
     repo_cmd = "echo -e '[cloudpassage]\nname=CloudPassage\nbaseurl=#{base_url}' | sudo tee /etc/yum.repos.d/cloudpassage.repo > /dev/null"
     key_cmd = "sudo rpm --import http://packages.cloudpassage.com/cloudpassage.packages.key"
     check_key_installed = "sudo rpm -qa gpg-pubkey* | xargs -i rpm -qi {} | grep -i cloudpassage"
     check_halo_installed = `sudo rpm -q cphalo -i`
     Chef::Log.info('Detected RPM-based OS')
     Chef::Log.info(check_halo_installed)
     update_repo_cmd = "sudo yum list > /dev/null"
end


# Exit recipe if check_halo_installed
    
if check_halo_installed != "" && check_halo_installed != "package cphalo is not installed\n"
    Chef::Log.info('Halo is installed already.')
    Chef::Log.info(check_halo_installed)
    return "Because Halo is installed, we're exiting RIGHT NOW"
else
    Chef::Log.info('Halo is not installed')
end


# add CloudPassage repository
execute "add-cloudpassage-repository" do
  command repo_cmd
  action :run
end

# import CloudPassage public key
execute "import-cloudpassage-public-key" do
  command key_cmd
  action :run
end

# update repositories
execute "update-repositories" do
  command update_repo_cmd
  action :run
end

# install the daemon
package "cphalo" do
  action :install
  Chef::Log.info('Installing the Halo LTA')
end

# start the daemon for the first time with the provided attributes.rb
# defined server_tag
execute "cphalo-start" do
  command "sudo /etc/init.d/cphalod start --daemon-key=#{node[:cloudpassage_halo]['daemon_key']} --tag=#{node[:cloudpassage_halo]['tag']} --debug"
  action :run
  Chef::Log.info('Starting Halo LTA with predefined key and tag')
end
