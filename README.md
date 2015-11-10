# CloudPassage Linux Cookbook

Version: 0.3.1  
Author: Eric Hoffmann - ehoffmann@cloudpassage.com

Revisions: Elijah Wright - ewright@cloudpassage.com


This cookbook installs Halo on Windows, Debian-based (Ubuntu, Debian), and RHEL-based (CentOS, Oracle) operating systems.


## Requirements and Dependencies

This cookbook relies on the yum, apt, and windows recipes.


## List of Files

'''
├── CHANGELOG.md     # Changelog
├── LICENSE.txt      # License
├── README.md        # This file
├── attributes      
│   └── default.rb   # Set your variables here...
├── metadata.rb      # About this recipe
└── recipes         
    └── default.rb   # The Halo agent installation recipe

'''

## Usage

The attributes file contains two default attributes that need to be replaced with your specific Halo daemon key and server-group tag name, as well as a number of other variables that should only be changed if you know they need to be different:

    default[:cloudpassage][:agent_key] = "abc123abc123abc123abc123abc123ab"
    default[:cloudpassage][:tag] = "chefRocks"

Command-line usage:

    knife bootstrap <your server instance FQDN> -x <root|ec2-user, other privileged user_name> -i “~/.ssh/<ssh_key>” -r "cloudpassage" --sudo

