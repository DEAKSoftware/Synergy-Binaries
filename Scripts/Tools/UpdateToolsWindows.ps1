$scriptBlock =
   {
   choco upgrade all

   pip3 install -r ToolRequirements.txt --upgrade

   refreshenv

   Write-Host "`nPress any key to continue..."
   [ void ][ System.Console ]::ReadKey( $true )
   }

Start-Process powershell -Verb runAs -ArgumentList $scriptBlock
# Start-Process powershell -ArgumentList $scriptBlock -NoNewWindow
