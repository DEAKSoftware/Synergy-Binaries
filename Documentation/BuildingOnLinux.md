## Building on Linux Mint / Ubuntu

### Prerequisites

1. Install Python 3:
	```sh
	sudo apt-get install python3 python3-pip python3-setuptools
	```

2. Run the installer script to configure additional dependencies, as noted below. If you wish to examine what packages will be installed, see package lists [`PackageListAPT.txt`](../Scripts/Install/PackageListAPT.txt) and [`PackageListPython.txt`](../Scripts/Install/PackageListPython.txt).

      * If Python is already installed:
         ```sh
         python.exe ./Scripts/install.py [--upgrade]
         ```
      * If Python is not installed:
         ```sh
         ./Scripts/Install/InstallLinux.sh [--upgrade]
         ```

      Use the `--upgrade` switch to refresh packages at a later date.

### Building

Build the project with the following Python script. Packages will be copied into the [`Binaries`](../Binaries) directory.

```sh
./Scripts/build.py
```

Similarly, one can clean the project, which resets Git repositories to a clean state:

```sh
./Scripts/clean.py
```

### Launching Automatically

In Linux Mint we can launch `synergy` client automatically via _System Settings &rarr; Startup Applications_, then add an entry with the command:

```sh
/usr/bin/synergyc --name ClientName --daemon #.#.#.#
```

Substitute the `ClientName` with the local machine name, and the Synergy server IP `#.#.#.#` with whatever appropriate for your set-up.
