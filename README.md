cloudpassage-chef-cookbook
==========================

Chef recipes using the CloudPassage Halo API
<!-- Write your ReadMe in markdown format, using this template. Use the GitHub Flavored markdown, as described here:
* https://help.github.com/articles/github-flavored-markdown -- most of what you need
* http://daringfireball.net/projects/markdown/syntax -- additional markdown details & background> -->


#CloudPassage Linux Cookbook

Version: 1.0  
Author: Eric Hoffmann - ehoffmann@cloudpassage.com

Revisions: Elijah Wright - ewright@cloudpassage.com

<!-- high-level summary of what this tool does and why it is useful. At least one paragraph -->

This cookbook installs Halo on Windows, Debian-based (Ubuntu, Debian), and RHEL-based (CentOS, Oracle) operating systems.


##Requirements and Dependencies
<!-- required packages, gems, libraries, other entities that this program needs to run.
Use asterisk-space if you want to make a bullet item.   -->

This cookbook relies on the yum, apt, and windows recipes.


##List of Files
<!-- list all libraries, scripts, other files provided with this tool.
Use asterisk-space if you want to make a bullet item.  -->

* recipes/default.rb - the recipe
* attributes/default.rb - attributes file.  Contains installation variables, proxy settings, etc...


##Usage
<!-- show a typical usage statement, syntax diagram, or step-by-step usage instructions.  -->
<!-- Indent code blocks and command-line examples 4 spaces -->
<!-- Show output examples, if useful -->
<!-- Make subsections if desired. Use 3 hashmarks and asterisks for subheadings, e.g., "###*Required Customizations:*" -->

The attributes file contains two default attributes that need to be replaced with your specific Halo daemon key and server-group tag name, and a bunch of other values that should only be changed if you know they need to be different:

    default[:cloudpassage][:daemon_key] = "abc123abc123abc123abc123abc123ab"
    default[:cloudpassage][:tag] = "chefRocks"

Command-line usage:

    knife bootstrap <your server instance FQDN> -x <root|ec2-user, other privileged user_name> -i “~/.ssh/<ssh_key>” -r "cloudpassage" --sudo

<!-- NOTE: Do not include license material in this file; that belongs in LICENSE.txt and in the source-code files themselves. -->

<!---
#CPTAGS:community-supported automation deployment
#TBICON:images/ruby_icon.png
-->
