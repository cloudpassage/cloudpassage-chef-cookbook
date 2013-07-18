#
# Cookbook Name:: cloudpassage_linux
# Recipe:: default
#
# Copyright 2013, CloudPassage
#
# determine OS and relevant package_mgr cmds
case node[:platform]
  when "debian", "ubuntu"
    base_url = "http://packages.cloudpassage.com/debian debian main"
    repo_cmd = "echo 'deb #{base_url}' | sudo tee /etc/apt/sources.list.d/cloudpassage.list > /dev/null"
    key_cmd = "curl http://packages.cloudpassage.com/cloudpassage.packages.key | sudo apt-key add -"
    check_key_installed = "sudo apt-key list | grep -i cloudpassage"
    update_repo_cmd = "sudo apt-get update"

  when "centos", "fedora", "rhel", "redhat", "amazon"
    base_url = "http://packages.cloudpassage.com/redhat/$basearch\ngpgcheck=1"
    repo_cmd = "echo -e '[cloudpassage]\nname=CloudPassage\nbaseurl=#{base_url}' | sudo tee /etc/yum.repos.d/cloudpassage.repo > /dev/null"
    key_cmd = "sudo rpm --import http://packages.cloudpassage.com/cloudpassage.packages.key"
    check_key_installed = "sudo rpm -qa gpg-pubkey* | xargs -i rpm -qi {} | grep -i cloudpassage"
    update_repo_cmd = "sudo yum list > /dev/null"
end

# add CloudPassage repository
execute "add-cloudpassage-repository" do
  command "#{repo_cmd}"
  action :run
end

# import CloudPassage public key
execute "import-cloudpassage-public-key" do
  command "#{key_cmd}"
  action :run
  not_if check_key_installed
end

# update repositories
execute "update-repositories" do
  command "#{update_repo_cmd}"
  action :run
end

# install the daemon
package "cphalo" do
  action :install
end

# start the daemon for the first time with the provided attributes.rb
# defined server_tag
execute "cphalo-start" do
  command "sudo /etc/init.d/cphalod start --daemon-key=#{node[:cloudpassage_linux]['daemon_key']} --tag=#{node[:cloudpassage_linux][:tag]}"
  action :run
end
