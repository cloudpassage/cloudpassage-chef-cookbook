![CloudPassage Logo](https://www.cloudpassage.com/wp-content/themes/cloudpassage-2015/images/logo.svg)

# cloudpassage Cookbook

Version: 4.0.3

Author: CloudPassage

[www.cloudpassage.com](https://www.cloudpassage.com)

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

 - Ubuntu 12.04, 14.04, 16.04
 - CentOS 6.7, 7.1
 - Debian 7, 8
 - RHEL 7.3
 - Amazon Linux 2015.09, 2016.09, 2017.03
 - Windows Server 2008R2, 2012R2

### Tested Chef Versions (Using Chef DK 2.5.3)
 - chef-client 12.9.38
 - chef-client 12.9.41
 - chef-client 12.10.24
 - chef-client 12.11.18
 - chef-client 12.12.13
 - chef-client 12.15.19
 - chef-client 12.20.3
 - chef-client 13.0.113
 - chef-client 13.0.118
 - chef-client 13.8.5

## Recipe cloudpassage::default usage:

The following attributes are configurable via the attributes/default.rb file:

    default['cloudpassage']['agent_key'] # Key used for agent registration
    default['cloudpassage']['grid_url'] # Normally https://grid.cloudpassage.com/grid
    default['cloudpassage']['linux_agent_version'] # Force a specific version of the Halo agent.
    default['cloudpassage']['azure_id'] # Used to build server label as azureid_hostname. If server_label field is defined, that will take precendence.
    default['cloudpassage']['proxy_host']
    default['cloudpassage']['proxy_port']
    default['cloudpassage']['proxy_user']
    default['cloudpassage']['proxy_password']
    default['cloudpassage']['read_only'] # Start the agent in read-only mode
    default['cloudpassage']['server_tag'] # Used for server group association
    default['cloudpassage']['server_label'] # Manually-defined label for server.
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

## Agent Upgrade

The Linux halo version of the agent will be updated to the latest by default. If the version of the halo agent is not the latest on your node, bootstrapping the node again will update its agent version to the latest.

The Windows halo version does not update automatically, the specific windows agent version must be specified in attributes/default.rb file.

Edit the following parameter's value (For Example):
```

default['cloudpassage']['windows_installer_file_name'] = 'cphalo-4.1.3-win64.exe'

```

## Resource cloudpassage_agent usage:

The cloudpassage::default recipe calls the cloudpassage_agent resource with
action :install.  You can call this resource directly from another recipe
as simply as:

    cloudpassage_agent 'halo' do
      agent_key AGENT_KEY_GOES_HERE
      server_tag SERVER_TAG_GOES_HERE
      action :install
    end

The reconfigure action forces reconfiguration of the agent:

    cloudpassage_agent 'halo' do
      agent_key AGENT_KEY_GOES_HERE
      server_tag SERVER_TAG_GOES_HERE
      action :reconfigure
    end

The remove action uninstalls the agent:

    cloudpassage_agent 'halo' do
      action :remove
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
| azure_id                    | This is a user-defined string that is combined with the hostname to serve as a label    |
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

<!---
#CPTAGS:community-supported automation deployment
#TBICON:images/ruby_icon.png
-->
