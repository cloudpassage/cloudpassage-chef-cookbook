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
