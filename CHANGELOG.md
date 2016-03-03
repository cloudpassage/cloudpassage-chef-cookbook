# CHANGELOG for cloudpassage

## 0.1.0:

* Initial release of cloudpassage_linux

## 0.2.0:

* Added support for proxy in Halo startup options
* Changed to using platform_family instead of platform and lists of OSes for determining which pkg mgr to use
* Added logic to print platform and platform version, as a reference by which to create logic to set server tag based on OS/ver
* Moved repo and repo key variables to attributes, to make it easier for those who run private mirrors.

## 0.3.0:

* Consolidating down into one recipe for all platforms (now just referred to as 'cloudpassage')

## 0.3.1:

* Corrected metadata.rb, populated README.md, corrected version in README.md

## 2.0.0:

* Re-work of entire cookbook.  Provides cloudpassage_agent resource for installing agent.

## 2.1.0:

* Added compat_resource to enable chef-client 12.5.1 compatibility.

## 2.2.0:

* Added linux_agent_version property to force specific version of Halo agent

* Documentation improvements

* Force failure on absence of agent key

* Added rake task ec2 for style, spec, and ec2 checks (thanks @rgindes)

## 2.2.1:

* Corrected deprecated code ahead of Chef 13

## 2.2.2:

* Pinned deps in Rakefile

## 2.2.3:

* Pinned test-kitchen dependency

## 2.3.0:

* Added security group identifier to kitchen-ec2

## 2.3.1:

* Corrected variable name for security_group_ids

## 2.4.0:

* Allow use of user_data variable in ec2 testing

## 2.4.1:

* Pinning more vars in Gemfile

## 2.4.2:

* Corrected versions in metadata.rb

## 2.5.0:

* Support Amazon Linux 2015.09 (improve override for svc manager), include in kitchen-ec2 config. (203)

* Increased concurrency (207)

* Added linux agent version to kitchen_ec2 config (208)

* Override retryable_tries in kitchen-ec2 config to accommodate occasionally slow Windows provisioning
