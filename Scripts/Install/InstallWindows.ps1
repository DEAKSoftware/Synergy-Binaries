param( [ parameter( mandatory = $false ) ] [ switch ] $upgrade )

$installBlock =
   {
   param( [ string ] $installToolsPath )

   Set-ExecutionPolicy Bypass -Scope Process -Force
   [ System.Net.ServicePointManager ]::SecurityProtocol = [ System.Net.ServicePointManager ]::SecurityProtocol -bor 3072
   iex ( ( New-Object System.Net.WebClient ).DownloadString( 'https://chocolatey.org/install.ps1' ) )

   $packageListChocoPath = Join-Path -Path $installToolsPath -ChildPath "PackageListChoco.config"
   choco install "$packageListChocoPath"
   refreshenv

   $packageListPythonPath = Join-Path -Path $installToolsPath -ChildPath "PackageListPython.txt"
   pip3 install -r "$packageListPythonPath"
   refreshenv

   Write-Host "`nPress any key to continue..."
   [ void ][ System.Console ]::ReadKey( $true )
   }

$upgradeBlock =
   {
   param( [ string ] $installToolsPath )

   $packageListChocoPath = Join-Path -Path $installToolsPath -ChildPath "PackageListChoco.config"
   choco upgrade all
   refreshenv

   $packageListPythonPath = Join-Path -Path $installToolsPath -ChildPath "PackageListPython.txt"
   pip3 install -r "$packageListPythonPath" --upgrade
   refreshenv

   Write-Host "`nPress any key to continue..."
   [ void ][ System.Console ]::ReadKey( $true )
   }

if ( $upgrade )
   {
   Start-Process powershell -Verb runAs -ArgumentList "-command & {$upgradeBlock} '$PSScriptRoot'"
   }
else
   {
   Start-Process powershell -Verb runAs -ArgumentList "-command & {$installBlock} '$PSScriptRoot'"
   }

exit 0
