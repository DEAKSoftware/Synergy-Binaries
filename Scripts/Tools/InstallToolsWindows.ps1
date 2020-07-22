$scriptBlock =
   {
   Write-Host "Installing tool..."

   Set-ExecutionPolicy Bypass -Scope Process -Force
   [ System.Net.ServicePointManager ]::SecurityProtocol = [ System.Net.ServicePointManager ]::SecurityProtocol -bor 3072
   iex ( ( New-Object System.Net.WebClient ).DownloadString( 'https://chocolatey.org/install.ps1' ) )

   choco install python3 git 
   choco install cmake.install --installargs '"ADD_CMAKE_TO_PATH=System"'

   refreshenv

   pip3 install -r ToolRequirements.txt

   refreshenv

   Write-Host "`nPress any key to continue..."
   [ void ][ System.Console ]::ReadKey( $true )
   }

Start-Process powershell -Verb runAs -ArgumentList $scriptBlock
# Start-Process powershell -ArgumentList $scriptBlock -NoNewWindow
