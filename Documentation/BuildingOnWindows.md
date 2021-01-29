## Building on Windows

### Prerequisites

1. Install the following tools and dependencies:

      * [Chocolatey](https://chocolatey.org/)
      * [Python 3](https://www.python.org/downloads/windows/)
      * [Visual Studio 2019](https://visualstudio.microsoft.com/downloads/), select the following components:
         * VS 2019 C++ x64/x86 build tools
         * Windows 10 SDK
      * [WiX Toolset](https://wixtoolset.org/releases/), install the following components:
         * WiX Toolset Build Tools
         * WiX Toolset Visual Studio 2019 Extension
      * [Qt 5](https://www.qt.io/download/), select the following components:
         * Qt 5.12.9 / MSVC 2017 64-bit

2. Edit the [`Scripts\config.txt`](../Scripts/config.txt) file and make sure the following variables are configured properly under the `[Windows]` section:

      * `libQtPath` -- Full path to the Qt library, Visual C++, 64-bit build.
      * `vcvarsallPath` -- Full path to Visual Studio's `vcvarsall.bat` command script. This sets the necessary compiler environment variables for building. See [Microsoft C++ toolset documentation](https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=vs-2019) for details.
      * `cmakeGenerator` -- Specifies the generator setting for cmake. Run `cmake --help` to choose a suitable generator that best matches the Visual Studio version installed earlier.

3. Run the installer script to configure additional dependencies, as noted below. If you wish to examine what packages will be installed, see package lists [`PackageListChoco.config`](../Scripts/Install/PackageListChoco.config) and [`PackageListPython.txt`](../Scripts/Install/PackageListPython.txt).

      * If Python is already installed:
         ```bat
         python.exe Scripts\install.py [--upgrade]
         ```
      * If Python is not installed:
         ```bat
         powershell.exe -File Scripts\Install\InstallWindows.ps1 [-upgrade]
         ```

      Use the `--upgrade` switch (Python), or the `-upgrade` switch (PowerShell) to refresh packages at a later date.

### Building

Build the project with the following Python script. Packages will be copied into the [`Binaries`](../Binaries) directory.

```bat
python.exe Scripts\build.py
```

To build a specific version of the product, supply the appropriate tag name (or commit hash) as an argument:

```sh
python.exe Scripts\build.py --checkout 1.13.1.3-snapshot
```

Similarly, one can clean the project, which resets Git repositories to a clean state:

```bat
python.exe Scripts\clean.py
```
