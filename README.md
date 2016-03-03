![CloudPassage Logo](https://www.cloudpassage.com/wp-content/themes/cloudpassage-2015/images/logo.svg)

# cloudpassage Cookbook

Version: 2.5.0

Author: CloudPassage

Master branch: [![Build Status](https://travis-ci.org/cloudpassage/cloudpassage-chef-cookbook.svg?branch=master)](https://travis-ci.org/cloudpassage/cloudpassage-chef-cookbook)

Develop branch: [![Build Status (develop branch)](https://travis-ci.org/cloudpassage/cloudpassage-chef-cookbook.svg?branch=develop)](https://travis-ci.org/cloudpassage/cloudpassage-chef-cookbook)

Feedback: toolbox@cloudpassage.com

## Scope

This cookbook installs and upgrades CloudPassage Halo on Windows, Debian-based
(Debian, Ubuntu) and RHEL-based (RHEL, CentOS, Oracle) operating systems.

This cookbook supports installation by resource, which is the preferred method.  
Optionally, you can also use the default recipe, but you'll need to provide configuration
information via attributes or data bag.

## Requirements and dependencies
### Tested and Supported Platforms

 - Ubuntu 12.04
 - Ubuntu 14.04
 - CentOS 6.7
 - CentOS 7.1
 - RHEL 7.2
 - Amazon Linux 2015.09
 - Windows Server 2012R2

### Tested Chef Versions

 - chef-client 12.5.1 (using Chef DK 0.9.0)
 - chef-client 12.6 (using Chef DK 0.10.0)

### Cookbooks

 - apt
 - yum

## Recipe cloudpassage::default usage:

The following attributes are configurable via the attributes/default.rb file:

    default['cloudpassage']['agent_key'] # Key used for agent registration
    default['cloudpassage']['grid_url'] # Normally https://grid.cloudpassage.com/grid
    default['cloudpassage']['linux_agent_version'] # Force a specific version of the Halo agent.
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

The default recipe is very versatile, and under most circumstances you will not
need to configure much more than the ```agent_key``` and ```server_tag``` node
attributes.  But if you want to go nuts with it, the functionality is there.



The following configuration options, if delivered in an encrypted data bag, will
override the defaults in the attributes file:

    agent_key
    proxy_user
    proxy_password

## Resource cloudpassage_agent usage:

The cloudpassage::default recipe calls the cloudpassage_agent resource with
action :install.  You can call this resource directly from another recipe
as simply as:

    cloudpassage_agent 'halo' do
      agent_key AGENT_KEY_GOES_HERE
      server_tag SERVER_TAG_GOES_HERE
      action :install
    end

Don't forget to add ```depends 'cloudpassage'``` to your metadata.rb file if
you're including the resource in another cookbook.

As with the recipe, you can accept almost all the defaults and rock and roll.  
You don't even have to define the ```server_tag```, but you'll spend a lot of
time manually organizing your hosts in the CloudPassage Halo portal if you
don't.

For your reading pleasure, here is an exhaustive list of properties for the
cloudpassage_halo resource:


| What it is                  | What it does                                                                            |
|-----------------------------|-----------------------------------------------------------------------------------------|
| agent_key                   | You MUST define this.  The default value will not register.                             |
| grid_url                    | Only override this if you're running on your own grid.                                  |
| linux_agent_version         | This forces a specific version of the Linux agent.                                      |
| proxy_host                  | Tells the agent to use a proxy                                                          |
| proxy_port                  | Defines the port for the proxy                                                          |
| proxy_user                  | Define a username for proxy use                                                         |
| proxy_password              | Define a password for proxy use                                                         |
| read_only                   | Set to ```true``` to run the agent in audit mode                                        |
| server_tag                  | This determines group placement on agent activation                                     |
| server_label                | This is a user-defined string that supersedes the hostname when rendered in the portal. |
| dns                         | Set this to ```false``` to disable DNS resolution by the agent.                         |
| windows_installer_protocol  | Used for assembling the URL for the Windows installer.                                  |
| windows_installer_port      | Used for assembling the URL for the Windows installer.                                  |
| windows_installer_host      | Used for assembling the URL for the Windows installer.                                  |
| windows_installer_path      | Used for assembling the URL for the Windows installer.                                  |
| windows_installer_file_name | Used for assembling the URL for the Windows installer.                                  |
| apt_repo_url                | Only change this if you're running your own repository.                                 |
| apt_repo_distribution       | Only change this if you're running your own repository.                                 |
| apt_repo_components         | Only change this if you're running your own repository.                                 |
| yum_repo_url                | Only change this if you're running your own repository.                                 |
| apt_key_url                 | Only change this if you're running your own repository.                                 |
| yum_key_url                 | Only change this if you're running your own repository.                                 |




Note: If the repo URL is configured as an empty string, the recipe will not
attempt to add the appropriate CloudPassage repository on the node.
