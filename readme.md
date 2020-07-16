# Synergy Binaries

Synergy is a keyboard and mouse sharing tool for devices connected over a network. Up until version 1.8.8, binaries were freely available to download from the official project website. Since then, [Synergy maintainers](https://github.com/symless/synergy-core) have decided to publish binaries behind a pay wall. However, Synergy is an open source project, and therefore anyone can build the application on their system.

This repository provides some convenience tools and documentation for building Synergy. Alternatively, one can also [download](https://github.com/DEAKSoftware/Synergy-Binaries/releases) the pre-compiled binaries.

Information presented here is based on the [official wiki pages](https://github.com/symless/synergy-core/wiki/Compiling). Anyone attempting to build Synergy should consult the official wiki pages first.


## Download Binaries

See [releases section](https://github.com/DEAKSoftware/Synergy-Binaries/releases) to locate binaries for your machine.

If you can't locate a binary package for your distribution, consider building the project yourself.


## Project Structure

The following files or directories should be of interest:

File / Directory                         | Description
---                                      | ---
[`Binaries`](./Binaries)                 | Output location for the build binaries.
`Synergy-Core`                           | The official Synergy Core submodule.
[`Tools`](./Tools)                       | Temporary location for build tools.
[`buildLinux.sh`](./buildLinux.sh)       | Shell script for building binaries in Linux Mint or Ubuntu.

<!--
[`buildMacOS.sh`](./buildMacOS.sh)       | Shell script for building binaries in macOS.
[`buildWindows.ps1`](./buildWindows.ps1) | PowerShell script for building binaries in Windows.
 -->

## Cloning the Repository

Before you begin building Synergy, you need to recursively clone this project and its submodules:

1. Clone the repository:

		git clone https://github.com/DEAKSoftware/Synergy-Binaries.git

2. Update all submodules:

		cd Synergy-Binaries
		git submodule update --init --remote --recursive


## Linux Mint / Ubuntu

### Prerequisites

Install the following packages:

	sudo apt install qtcreator qtbase5-dev qttools5-dev cmake make g++ xorg-dev libssl-dev libx11-dev libsodium-dev libgl1-mesa-glx libegl1-mesa libcurl4-openssl-dev libavahi-compat-libdnssd-dev qtdeclarative5-dev libqt5svg5-dev libsystemd-dev

Alternatively, consult the [official wiki](https://github.com/symless/synergy-core/wiki/Compiling) for installing dependencies.

### Building

Run the shell script with `buildLinux.sh --all` to build all packages. For other options, run with the `--help` switch.

Alternatively, you can opt to build the binaries only, as detailed below. We're assuming the current path is in the `Synergy-Binaries` project root.

1. Create a `build` subdirectory in the `Synergy-Core` submodule:

		cd Synergy-Core
		mkdir build
		cd build

2. Configure the project:

		cmake .. -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON

3. Build the project:

		cmake --build . --parallel 8

4. Optional, install the application:

		sudo cmake --install .

### Launching Automatically

In Linux Mint we can launch `synergy` client automatically via _System Settings &rarr; Startup Applications_, then add an entry with the command:

	/usr/local/bin/synergy --name ClientName --daemon #.#.#.#

Substitute the `ClientName` with the local machine name, and the Synergy server IP `#.#.#.#` with whatever appropriate for your set-up.

<!--
## macOS

_Incomplete._

## Windows

_Incomplete._
 -->

## Disclaimers and Legal

DEAK Software is not the maintainer of Synergy, nor is affiliated with Symless in anyway way. Bugs or issues related to the application should be reported directly on the [official Synergy GitHub page](https://github.com/symless/synergy-core).

This project is released under the [MIT License](./license.md).
