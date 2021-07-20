@echo off

:main

   if [%vcvarsallPath] equ [] (
      echo error: The required environment variables were not configured.
      exit 1
   )

   call "%vcvarsallPath%" x64 || exit 1

   call :configureCMake
   call :buildBinaries
   call :buildMSI
   call :buildZIP

   exit 0

:configureCMake

   cmake -S "%productRepoPath%" -B "%productBuildPath%"^
      -G "%cmakeGenerator%"^
      -D CMAKE_PREFIX_PATH="%libQtPath%;%openSSLPath%"^
      -D CMAKE_BUILD_TYPE=Release^
      -D SYNERGY_ENTERPRISE=ON^
      -D SYNERGY_REVISION="%productRevision%"^
       || exit 1

   exit /b 0

:buildBinaries

   pushd "%productBuildPath%" || exit 1

      msbuild synergy-core.sln /p:Platform="x64" /p:Configuration=Release /m || exit 1

   popd

   exit /b 0

:buildMSI

   pushd "%productBuildPath%\installer" || exit 1

      msbuild Synergy.sln /p:Configuration=Release || exit 1

   popd

   copy "%productBuildPath%\installer\bin\Release\Synergy.msi" "%binariesPath%" || exit 1
   del "%binariesPath%\%productPackageName%.msi"
   ren "%binariesPath%\Synergy.msi" "%productPackageName%.msi" || exit 1

   exit /b 0

:buildZIP

   setlocal

   set sourcePath=%productBuildPath%\bin\Release
   set productPath=%productBuildPath%\bin\%productPackageName%

   mkdir "%productPath%"

   copy "%sourcePath%\libEGL.dll"     "%productPath%" || exit 1
   copy "%sourcePath%\libGLESv2.dll"  "%productPath%" || exit 1
   copy "%sourcePath%\Qt5Core.dll"    "%productPath%" || exit 1
   copy "%sourcePath%\Qt5Gui.dll"     "%productPath%" || exit 1
   copy "%sourcePath%\Qt5Network.dll" "%productPath%" || exit 1
   copy "%sourcePath%\Qt5Svg.dll"     "%productPath%" || exit 1
   copy "%sourcePath%\Qt5Widgets.dll" "%productPath%" || exit 1
   copy "%sourcePath%\synergy.exe"    "%productPath%" || exit 1
   copy "%sourcePath%\synergyc.exe"   "%productPath%" || exit 1
   copy "%sourcePath%\synergyd.exe"   "%productPath%" || exit 1
   copy "%sourcePath%\synergys.exe"   "%productPath%" || exit 1
   copy "%sourcePath%\syntool.exe"    "%productPath%" || exit 1

   mkdir "%productPath%\Platforms"
   copy "%sourcePath%\Platforms" "%productPath%\Platforms" || exit 1

   mkdir "%productPath%\Styles"
   copy "%sourcePath%\Styles" "%productPath%\Styles" || exit 1

   mkdir "%productPath%\OpenSSL"
   copy "%productRepoPath%\ext\openssl\windows\x64\bin\*" "%productPath%\OpenSSL" || exit 1
   copy "%productRepoPath%\ext\openssl\windows\x64\bin\*.dll" "%productPath%" || exit 1

   set zipPath=%binariesPath%\%productPackageName%.zip

   powershell.exe -nologo -noprofile -command "& { Compress-Archive -Force -Path '%productPath%' -DestinationPath '%zipPath%' }" || exit 1

   endlocal
   exit /b 0
