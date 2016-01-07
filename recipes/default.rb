#
# Cookbook Name:: cloudpassage
# Recipe:: default
#
# Copyright 2015, CloudPassage
# Before we get this party started, set the environment variable for proxy...

# First we build the proxy string
if node[:cloudpassage][:proxy_url] != "" then
    ENV['http_proxy'] = "#{node[:cloudpassage][:proxy_url]}"
    if (node[:cloudpassage][:proxy_user] != "") && (node[:cloudpassage][:proxy_pass] != "") then
        proxy_string_lin = "--proxy=\"#{node[:cloudpassage][:proxy_url]}\" --proxy-user=\"#{node[:cloudpassage][:proxy_user]}\" --proxy-password=\"#{node[:cloudpassage][:proxy_pass]}\""
        proxy_string_win = "/proxy=\"#{node[:cloudpassage][:proxy_url]}\" /proxy-user=\"#{node[:cloudpassage][:proxy_user]}\" /proxy-password=\"#{node[:cloudpassage][:proxy_pass]}\""
    else
        proxy_string_lin = "--proxy=\"#{node[:cloudpassage][:proxy_url]}\""
        proxy_string_win = "/proxy=\"#{node[:cloudpassage][:proxy_url]}\""
    end
else
    proxy_string_lin = ""
    proxy_string_win = ""
end
# Next we determine the server tag string
if node[:cloudpassage][:proxy_url] != "" then
    tag_string_lin = "--tag=#{node[:cloudpassage][:tag]}"
    tag_string_win = "/tag=#{node[:cloudpassage][:tag]}"
else
    tag_string_lin = ""
    tag_string_win = ""
end
# Set up repositories for Linux
case node[:platform_family]
    when "debian"
        apt_repository 'cloudpassage' do
            uri node[:cloudpassage][:deb_repo_url]
            key node[:cloudpassage][:deb_key_location] 
        end
    when "rhel"
        yum_repository 'cloudpassage' do
            description  "CloudPassage Halo Repository"
            baseurl  "#{node[:cloudpassage][:rpm_repo_url]}"
            gpgkey  "#{node[:cloudpassage][:rpm_key_location]}"
            action :create
        end
end
# Install and register the Halo agent
case node[:platform_family]
    when "debian", "rhel"
        p_serv_name = "cphalod"
        startup_opts_lin = "--agent-key=#{node[:cloudpassage]['agent_key']} #{tag_string_lin} --grid=\"#{node[:cloudpassage][:grid]}\" #{proxy_string_lin}" 
        package 'cphalo' do
            action :install
        end
        # We'll start it up and shut it down using the init script.
        # We will leave it off because later we'll start and enable it 
        # using the platform's service manager.

        execute "cphalo-config" do
          command "sudo /opt/cloudpassage/bin/configure --agent-key=#{node[:cloudpassage]['agent_key']} --tag=#{node[:cloudpassage]['tag']} --server-label=#{node[:cloudpassage]['label']} --read-only=#{node[:cloudpassage]['readonly']} --dns=#{node[:cloudpassage]['usedns']}"
          action :run
        end

        execute "cphalo-start" do
            command "sudo /etc/init.d/cphalod start"
            action :run
            not_if "sudo ps x | grep cphalo | grep -v grep"
        end
        execute "cphalo-stop" do
            command "sudo /etc/init.d/cphalod stop"
            only_if "sudo ps x | grep cphalo | grep -v grep"
        end
    when "windows"
        p_serv_name = "CloudPassage Halo Agent"
        startup_opts_win = "/agent-key=#{node[:cloudpassage]['agent_key']} #{tag_string_win} /grid=\"#{node[:cloudpassage][:grid]}\" #{proxy_string_win}" 
        windows_package 'CloudPassage Halo' do
            source node[:cloudpassage][:win_installer_location]
            options "/S #{startup_opts_win} /NOSTART"
            installer_type :custom
            action :install
        end
end
# Now we start the agent using the platform's service manager!
service "#{p_serv_name}" do
    action [ "enable", "start"]
end
