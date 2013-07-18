<!-- Write your ReadMe in markdown format, using this template. Use the GitHub Flavored markdown, as described here:
* https://help.github.com/articles/github-flavored-markdown -- most of what you need
* http://daringfireball.net/projects/markdown/syntax -- additional markdown details & background> -->


#CloudPassage Linux Cookbook

Version: 1.0  
Author: Eric Hoffmann - ehoffmann@cloudpassage.com

<!-- high-level summary of what this tool does and why it is useful. At least one paragraph -->

This cookbook installs Halo on Debian, Ubuntu, CentOS, Fedora, RHEL and Amazon Linux servers.


##Requirements and Dependencies
<!-- required packages, gems, libraries, other entities that this program needs to run.
Use asterisk-space if you want to make a bullet item.   -->

The default recipe relies on sudo and curl being installed. It does not list them as cookbook dependencies.


##List of Files
<!-- list all libraries, scripts, other files provided with this tool. 
Use asterisk-space if you want to make a bullet item.  -->

* default.rb - the cookbook
* default.rb - attributes file


##Usage
<!-- show a typical usage statement, syntax diagram, or step-by-step usage instructions.  -->
<!-- Indent code blocks and command-line examples 4 spaces -->
<!-- Show output examples, if useful --> 
<!-- Make subsections if desired. Use 3 hashmarks and asterisks for subheadings, e.g., "###*Required Customizations:*" -->

The attributes file contains two default attributes that need to be replaced with your specific Halo daemon key and server-group tag name:

    default[:cloudpassage_linux][:daemon_key] = "abc123abc123abc123abc123abc123ab"
    default[:cloudpassage_linux][:tag] = "chefRocks"

Command-line usage:

    knife bootstrap <your server instance FQDN> -x <root|ec2-user, other privileged user_name> -i “~/.ssh/<ssh_key>” -r "cloudpassage_linux" --sudo

<!-- NOTE: Do not include license material in this file; that belongs in LICENSE.txt and in the source-code files themselves. -->
