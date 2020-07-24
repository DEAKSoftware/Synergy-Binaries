## Getting Started

### Cloning This Repository

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
[`Binaries`](./Binaries)                                   | Output location for the build products.
[`Documentation`](./Documentation)                         | Contains project documentation.
[`Synergy-Core`](https://github.com/symless/synergy-core/) | The official Synergy Core submodule.
[`Scripts`](./Scripts)                                     | Collection of Python build scripts.
[`Tools`](./Tools)                                         | Temporary location for build tools.
