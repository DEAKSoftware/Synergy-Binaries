## Cloning the Repository

### Preparation

Before you begin building Synergy, you need to recursively clone this project and its submodules:

1. Clone the repository:

   ```sh
   git clone https://github.com/DEAKSoftware/Synergy-Binaries.git
   ```

2. Update all submodules:

   ```sh
   cd Synergy-Binaries
   git submodule update --init --remote --recursive
   ```

### Project Structure

The following files or directories should be of interest:

File / Directory                                           | Description
---                                                        | ---
[`Binaries`](./Binaries)                                   | Output location for the build binaries.
[`Documentation`](./Documentation)                         | Documentation for various scripts.
[`Synergy-Core`](https://github.com/symless/synergy-core/) | The official Synergy Core submodule.
[`Tools`](./Tools)                                         | Temporary location for build tools.
[`buildLinux.sh`](./buildLinux.sh)                         | Shell script for building binaries in Linux Mint or Ubuntu.
[`buildMacOS.sh`](./buildMacOS.sh)                         | Shell script for building binaries in macOS.
[`buildWindows.cmd`](./buildWindows.cmd)                   | Command script for building binaries in Windows.
