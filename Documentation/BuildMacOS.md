## Building on macOS

### Prerequisites

1. Install the following tools and dependencies:

   * [Homebrew](http://brew.sh/)
   * [XCode](https://developer.apple.com/xcode/download/)
   * [Qt 5](https://www.qt.io/download), select the following components:
      * Qt 5.12.9, MSVC 2017 64-bit

2. Use Homebrew to install additional tools and libraries:

   ```sh
   brew install cmake libsodium openssl
   ```

### Compiling (Easy Mode)

Run the command script `buildMacOS.sh --all` to build all packages. For other options, run with the `--help` switch.

### Compiling (Hard Mode)

Alternatively, you can opt to build the binaries only, as detailed below. We're assuming the current path is in the `Synergy-Binaries` project root.
