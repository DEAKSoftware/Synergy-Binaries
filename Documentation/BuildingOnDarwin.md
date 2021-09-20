## Building on macOS

### Prerequisites

1. Install the following tools and dependencies:

      * [Homebrew](http://brew.sh/)
      * [Python 3](https://www.python.org/downloads/windows/)
      * [XCode](https://developer.apple.com/xcode/download/)
      * [Qt5](https://download.qt.io/official_releases/qt/)

2. Run the installer script to configure additional dependencies, as noted below. If you wish to examine what packages will be installed, see package lists [`PackageListBrew.txt`](../Scripts/Install/PackageListBrew.txt) and [`PackageListPython.txt`](../Scripts/Install/PackageListPython.txt).

      * If Python is already installed:
         ```sh
         ./Scripts/install.py [--upgrade]
         ```
      * If Python is not installed:
         ```sh
         ./Scripts/Install/InstallDarwin.sh [--upgrade]
         ```

      Use the `--upgrade` switch to refresh packages at a later date.

3. Edit the [`Scripts/config.txt`](../Scripts/config.txt) file and make sure the following variables are configured properly under the `[Darwin]` section:

      * `libQtPath` -- Full path to the Qt library (query with `brew --prefix qt5`).
      * `openSSLPath` -- Full path to the OpenSSL library (query with `brew --prefix openssl`).

### Building

Build the project with the following Python script. Packages will be copied into the [`Binaries`](../Binaries) directory.

```sh
./Scripts/build.py
```

To build a specific version of the product, supply the appropriate tag name (or commit hash) as an argument:

```sh
./Scripts/build.py --checkout 1.13.1.3-snapshot
```

Similarly, one can clean the project, which resets Git repositories to a clean state:

```sh
./Scripts/clean.py
```
<!--
### Issues

If you are building on Apple M1 and having trouble linking `arm64` binaries with the Qt5 library, try the following. Install Qt build dependencies:

```sh
brew install pcre2 harfbuzz freetype
```

Reinstall Qt5 and build from source:

```sh
brew reinstall -s qt5
```
-->