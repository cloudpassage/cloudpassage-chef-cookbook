# cloudpassage Cookbook

Version: 1.0
Author: CloudPassage

## Scope

This cookbook installs and upgrades CloudPassage Halo on Windows, Debian-based
(Debian, Ubuntu) and RHEL-based (RHEL, CentOS, Oracle) operating systems.

## Requirements and dependencies
### Tested and Supported Platforms

 - Ubuntu 12.04
 - Ubuntu 14.04
 - CentOS 6.7
 - CentOS 7.1
 - RHEL 7.2
 - Windows Server 2008R2
 - Windows Server 2012R2

### Tested Chef Versions

 - chef-client 12.6

### Cookbooks

 - apt
 - yum

## Usage:

The following attributes are configurable via the attributes/default.rb file:

  default['cloudpassage']['agent_key'] # Key used for agent registration
  default['cloudpassage']['grid_url'] # Normally https://grid.cloudpassage.com/grid
  default['cloudpassage']['proxy_host']
  default['cloudpassage']['proxy_port']
  default['cloudpassage']['proxy_user']
  default['cloudpassage']['proxy_password']
  default['cloudpassage']['read_only'] # Start the agent in read-only mode
  default['cloudpassage']['server_tag'] # Used for server group association
  default['cloudpassage']['server_label'] # Manually-defined label for server
  default['cloudpassage']['dns'] # Disable agent DNS lookup
  default['cloudpassage']['windows_installer_protocol'] # Used in building the Windows package install string
  default['cloudpassage']['windows_installer_port'] # Port component of windows installer url
  default['cloudpassage']['windows_installer_host'] # Host portion of Windows installer URL
  default['cloudpassage']['windows_installer_path'] # Path to Windows installer
  default['cloudpassage']['windows_installer_file_name'] # Name of Windows installer executable
  default['cloudpassage']['apt_repo_url'] # Apt repo URL for CloudPassage Halo
  default['cloudpassage']['apt_repo_distribution']
  default['cloudpassage']['apt_repo_components']
  default['cloudpassage']['yum_repo_url'] # Apt repo URL for CloudPassage Halo
  default['cloudpassage']['apt_key_url']
  default['cloudpassage']['yum_key_url']



The following configuration options, if delivered in an encrypted data bag, will
override the defaults in the attributes file:

    agent_key
    proxy_user
    proxy_password


Note: If the repo URL is configured as an empty string, the recipe will not
attempt to add the appropriate CloudPassage repository on the node.
