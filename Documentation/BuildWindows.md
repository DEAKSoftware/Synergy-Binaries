## Building on Windows

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

   * `vcvarsallCommand` - Path to Visual Studio's `vcvarsall.bat` command script, which sets compiler environment variables. See [Microsoft C++ toolset documentation](https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=vs-2019) for details.

   * `cmakeGenerator` - Specifies the "generator" setting for cmake. Run `cmake --help` to choose the suitable generator for your current tool chain.

### Compiling (Easy Mode)

Run the command script `buildWindows.cmd --all` to build all packages. For other options, run with the `--help` switch.

### Compiling (Hard Mode)

Alternatively, you can opt to build the binaries only, as detailed below. We're assuming the current path is in the `Synergy-Binaries` project root.

```bat
cd Synergy-Core
mkdir build
cd build

call "c:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

cmake .. -G "Visual Studio 16 2019" -D CMAKE_PREFIX_PATH="c:\Qt\Qt5.12.9\5.12.9\msvc2017_64" -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON

msbuild synergy-core.sln /p:Platform="x64" /p:Configuration=Release /m
```
You may need to use different paths to `vcvarsall.bat` and Qt libraries, whatever is appropriate for your system. Consequently, the generator `-G` switch for `cmake` must also reflect the tool chain environment. See `cmake --help` for details.
