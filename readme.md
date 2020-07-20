# Synergy Binaries

[Synergy](https://github.com/symless/synergy-core) is a keyboard and mouse sharing tool for devices connected over a network. Up until version 1.8.8, binaries were freely available to download from the official project website. Since then, Synergy maintainers have decided to publish binaries behind a pay wall. However, Synergy is an open source project, and therefore anyone can build the application on their system.

This repository provides some convenience tools and documentation for building Synergy. Alternatively, one can also [download](https://github.com/DEAKSoftware/Synergy-Binaries/releases) the pre-compiled binaries.

Information presented here is based on the [official wiki pages](https://github.com/symless/synergy-core/wiki/Compiling). Anyone attempting to build Synergy should consult the official wiki pages first.


## Download Binaries

The following binaries available in the [Releases](https://github.com/DEAKSoftware/Synergy-Binaries/releases) section:

* Linux `AppImage`, `deb` packages
* Windows `MSI` installer, or standalone `ZIP` package
* macOS `dmg` packages

If you can't locate a binary package for your particular distribution, try building the project yourself.


## Project Structure

The following files or directories should be of interest:

File / Directory                                            | Description
---                                                         | ---
[`Binaries`](./Binaries)                                    | Output location for the build binaries.
[`Synergy-Core`](https://github.com/symless/synergy-core/)  | The official Synergy Core submodule.
[`Tools`](./Tools)                                          | Temporary location for build tools.
[`buildLinux.sh`](./buildLinux.sh)                          | Shell script for building binaries in Linux Mint or Ubuntu.
[`buildWindows.cmd`](./buildWindows.cmd)                    | Command script for building binaries in Windows.

<!-- [`buildMacOS.sh`](./buildMacOS.sh)                          | Shell script for building binaries in macOS. -->


## Official Documentation

If you choose to build Synergy manually, consult the following official documentation:

* [Compiling](https://github.com/symless/synergy-core/wiki/Compiling)
* [Compiling Synergy Core](https://github.com/symless/synergy-core/wiki/Compiling-Synergy-Core)
* [Building the Windows MSI Package](https://github.com/symless/synergy-core/wiki/Building-the-Windows-MSI-Package)

## Cloning the Repository

Before you begin building Synergy, you need to recursively clone this project and its submodules:

1. Clone the repository:

		git clone https://github.com/DEAKSoftware/Synergy-Binaries.git

2. Update all submodules:

		cd Synergy-Binaries
		git submodule update --init --remote --recursive


## Linux Mint / Ubuntu

### Prerequisites

Install the following tools and dependencies:

	sudo apt-get install \
		cmake g++ libavahi-compat-libdnssd-dev \
		libcurl4-openssl-dev libegl1-mesa \
		libgl1-mesa-glx libqt5svg5-dev libsodium-dev \
		libssl-dev libsystemd-dev libx11-dev \
		make qtbase5-dev qtcreator qtdeclarative5-dev \
		qttools5-dev xorg-dev

For building Debian packages:

	sudo apt-get install build-essential devscripts dh-make lintian

### Building

**Easy Mode:**

Run the shell script `buildLinux.sh --all` to build all packages. For other options, run with the `--help` switch.

**Hard Mode:**

Alternatively, you can opt to build the binaries only, as detailed below. We're assuming the current path is in the `Synergy-Binaries` project root.

	cd Synergy-Core
	mkdir build
	cd build

	cmake .. -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON

	cmake --build . --parallel 8

Optional, install the application:

	sudo cmake --install .

### Launching Automatically

In Linux Mint we can launch `synergy` client automatically via _System Settings &rarr; Startup Applications_, then add an entry with the command:

	/usr/bin/synergyc --name ClientName --daemon #.#.#.#

Substitute the `ClientName` with the local machine name, and the Synergy server IP `#.#.#.#` with whatever appropriate for your set-up.

<!--
## macOS

_Incomplete._
-->

## Windows

### Prerequisites

1. Install the following tools and dependencies:

	* [Git for Windows](https://gitforwindows.org/)
	* [CMake](https://cmake.org/)
	* [Visual Studio 2019](https://visualstudio.microsoft.com/downloads/), select the following components:
		* VS 2019 C++ x64/x86 build tools
		* Windows 10 SDK
	* [WiX Toolset](https://wixtoolset.org/releases/), install the following components:
		* WiX Toolset Build Tools
		* WiX Toolset Visual Studio 2019 Extension
	* [Qt 5](https://www.qt.io/download), select the following components:
		* Qt 5.12.9, MSVC 2017 64-bit

2. Edit the `buildWindows.cmd` script and make sure the following script variables are configured properly:

	* `libQtPath` - Path to the Qt library, Visual C++, 64-bit build.

	* `vcvarsallCommand` - Path to Visual Studio's `vcvarsall.bat` command script, which sets compiler environment variables. See [Microsoft C++ toolset](https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=vs-2019) documentation for details.

	* `cmakeGenerator` - Specifies the "generator" setting for cmake. Run `cmake --help` to choose the suitable generator for your current tool chain.

### Building

**Easy Mode:**

Run the command script `buildWindows.cmd --all` to build all packages. For other options, run with the `--help` switch.

**Hard Mode:**

Alternatively, you can opt to build the binaries only, as detailed below. We're assuming the current path is in the `Synergy-Binaries` project root.

	cd Synergy-Core
	mkdir build
	cd build

	call "c:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

	cmake .. -G "Visual Studio 16 2019" -D CMAKE_PREFIX_PATH="c:\Qt\Qt5.12.9\5.12.9\msvc2017_64" -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON

	msbuild synergy-core.sln /p:Platform="x64" /p:Configuration=Release /m

You may need to use different paths to `vcvarsall.bat` and Qt libraries, whatever is appropriate for your system. Consequently, the generator `-G` switch for `cmake` must also reflect the tool chain environment. See `cmake --help` for details.

## Disclaimers and Legal

DEAK Software is not the maintainer of Synergy, nor is affiliated with Symless in anyway way. Bugs or issues related to the application should be reported directly on the [official Synergy GitHub page](https://github.com/symless/synergy-core).

This project is released under the [MIT License](./license.md).
