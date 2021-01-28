# Synergy Binaries

## About

[Synergy](https://github.com/symless/synergy-core) is a keyboard and mouse sharing tool for devices connected over a network. This repository maintains Synergy binaries to download, including convenience tools and documentation for building the Synergy application.

## Download

* [Synergy 1.13.1.1-snapshot](https://github.com/DEAKSoftware/Synergy-Binaries/releases/tag/1.13.1.1-snapshot)
* [Synergy 1.12.0-stable](https://github.com/DEAKSoftware/Synergy-Binaries/releases/tag/1.12.0-stable)
* [Synergy 1.12.0-rc2](https://github.com/DEAKSoftware/Synergy-Binaries/releases/tag/1.12.0-rc2)
* [Synergy 1.12.0-rc1](https://github.com/DEAKSoftware/Synergy-Binaries/releases/tag/1.12.0-rc1)

Binaries are available for the following platforms:

* macOS 10.12 Sierra: `.dmg`
* Linux Mint 20 Ulyana: `.deb`, `.rpm`, `.AppImage`
* Windows 7: `.msi`, portable `.zip`

See [Releases](https://github.com/DEAKSoftware/Synergy-Binaries/releases) for additional versions. If a particular version is missing, [create a new issue](https://github.com/DEAKSoftware/Synergy-Binaries/issues/new/choose) to request new binaries. If you can't locate a binary package for your particular distribution, you might want to try building the project yourself.

## Building

The build system in this project where hacked together from information presented on the official Synergy Core [wiki pages](https://github.com/symless/synergy-core/wiki/), and from the Azure Pipeline [configuration files](https://github.com/symless/synergy-core/tree/master/CI/), found in the sources. Anyone attempting to build Synergy should consult the official wiki pages first, or use Azure Pipelines to generate all packages (if appropriate). Otherwise, you can try using the build scripts in this project.

1. Official Documentation
	* [Compiling](https://github.com/symless/synergy-core/wiki/Compiling), and [Compiling Synergy Core](https://github.com/symless/synergy-core/wiki/Compiling-Synergy-Core)
	* [Building the Windows MSI Package](https://github.com/symless/synergy-core/wiki/Building-the-Windows-MSI-Package)

2. Building the Binaries
	* [Getting Started](./Documentation/GettingStarted.md)
	* [Building on macOS](./Documentation/BuildingOnDarwin.md)
	* [Building on Linux Mint / Ubuntu](./Documentation/BuildingOnLinux.md)
	* [Building on Windows](./Documentation/BuildingOnWindows.md)

## Disclaimers and Legal

DEAK Software is not the maintainer of Synergy, nor is affiliated with Symless in any way. Bugs or issues related to the application should be reported directly on the [official Synergy GitHub page](https://github.com/symless/synergy-core).

This project is released under the [MIT License](./license.md).
