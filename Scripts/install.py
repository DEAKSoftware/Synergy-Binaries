#!/usr/bin/env python3

import os, platform, sys

basePath = os.path.dirname( os.path.realpath( __file__ ) )

scripts = {
   "Darwin"  : "Install/InstallDarwin.sh",
   "Linux"   : "Install/InstallLinux.sh",
   "Windows" : "Install\\InstallWindows.ps1",
   }

command = '"' + os.path.join( basePath, scripts[ platform.system() ] ) + '"'
arguments = ' ' + ' '.join( sys.argv[ 1: ] )

if platform.system() == "Windows":
    command = "powershell.exe -File " + command
    arguments = arguments.replace( "--", "-" )

command += arguments

print( command )

if os.system( command ) != 0:
   print( "Command exited with error." )
   raise SystemExit( 1 )
