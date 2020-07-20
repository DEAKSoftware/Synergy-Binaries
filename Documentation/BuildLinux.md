## Building on Linux Mint / Ubuntu

### Prerequisites

Install the following tools and dependencies:

```sh
sudo apt-get install \
   cmake g++ libavahi-compat-libdnssd-dev \
   libcurl4-openssl-dev libegl1-mesa \
   libgl1-mesa-glx libqt5svg5-dev libsodium-dev \
   libssl-dev libsystemd-dev libx11-dev \
   make qtbase5-dev qtcreator qtdeclarative5-dev \
   qttools5-dev xorg-dev
```

For building Debian packages:

```sh
sudo apt-get install build-essential devscripts dh-make lintian
```

### Compiling (Easy Mode)

Run the shell script `buildLinux.sh --all` to build all packages. For other options, run with the `--help` switch.

### Compiling (Hard Mode)

Alternatively, you can opt to build the binaries only, as detailed below. We're assuming the current path is in the `Synergy-Binaries` project root.

```sh
cd Synergy-Core
mkdir build
cd build

cmake .. -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON

cmake --build . --parallel 8
```

Optional, install the application:

```sh
sudo cmake --install .
```

### Launching Automatically

In Linux Mint we can launch `synergy` client automatically via _System Settings &rarr; Startup Applications_, then add an entry with the command:

```sh
/usr/bin/synergyc --name ClientName --daemon #.#.#.#
```

Substitute the `ClientName` with the local machine name, and the Synergy server IP `#.#.#.#` with whatever appropriate for your set-up.
