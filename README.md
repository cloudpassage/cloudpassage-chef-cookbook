# cloudpassage_halo Chef Cookbook

Version: 1.0
Author: CloudPassage

This cookbook installs CloudPassage Halo on Windows, Debian-based \
(Debian, Ubuntu) and RHEL-based (RHEL, CentOS, Oracle) operating systems.

## Requirements and dependencies

This cookbook depends on the yum and apt cookbooks.

## List of Files

TBD

## Usage:

The following attributes are configurable via the attributes/default.rb file:

    agent_key
    proxy_user
    proxy_password
    grid_url
    proxy_host
    proxy_port
    read_only
    server_tag
    server_label
    dns
    suppress_cloudpassage_repo
    windows_installer_protocol
    windows_installer_port
    windows_installer_host
    windows_installer_path
    windows_installer_file_name
    apt_repo_url
    apt_key_url
    yum_repo_url
    apt_key_url


The following configuration options, delivered in an encrypted data bag, will
override the defaults in the attributes file:
    agent_key
    proxy_user
    proxy_password


Note: If the repo URL is configured as an empty string, the recipe will not
attempt to add the appropriate CloudPassage repository on the node.
