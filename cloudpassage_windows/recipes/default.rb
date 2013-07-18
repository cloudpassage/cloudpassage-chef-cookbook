#
# Cookbook Name:: cloudpassage_windows
# Recipe:: default
#
# Copyright 2013, CloudPassage
#
powershell "install Halo" do
  code <<-EOH
  # download Halo installer, version defined as an attribute
  $webclient = New-Object System.Net.WebClient
  $webclient.DownloadFile("http://packages.cloudpassage.com/windows/#{node[:cloudpassage_windows][:halo_exe]}", "C:\\#{node[:cloudpassage_windows][:halo_exe]}");
  if ($Error)
  {
    Write-Output "ERROR:" "$Error"
    Exit 1
  }

  # install Halo and wait for it to complete
  # daemon_key and tag are defined as an attribute
  $installer = "C:\\#{node[:cloudpassage_windows][:halo_exe]}"
  &$installer /S /daemon-key="#{node[:cloudpassage_windows][:daemon_key]}" /tag="#{node[:cloudpassage_windows][:tag]}" | Out-Null
  if ($Error)
  {
    Write-Output "ERROR:" "$Error"
  }
  EOH
end
