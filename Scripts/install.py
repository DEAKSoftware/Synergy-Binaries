#!/usr/bin/env python3

import os, platform, sys

arguments = ""

if len( sys.argv ) > 1:
	if sys.argv[ 1 ] == "--upgrade":
		arguments += "--upgrade"
	elif sys.argv[ 1 ] == "-u":
		arguments += "--upgrade"
	else:
	   print( "error: Invalid argument. Use '--upgrade' switch to upgrade packages, or none to install packages." )
	   raise SystemExit( 1 )

basePath = os.path.dirname( os.path.realpath( __file__ ) )

scripts = {
   "Darwin"  : "Install/InstallDarwin.sh",
   "Linux"   : "Install/InstallLinux.sh",
   "Windows" : "Install\\InstallWindows.ps1",
   }

command = '"' + os.path.join( basePath, scripts[ platform.system() ] ) + '"'

if platform.system() == "Windows":
    command = "powershell.exe -File " + command
    arguments = arguments.replace( "--", "-" )

command += ' ' + arguments

print( command )

if os.system( command ) != 0:
   print( "Command exited with error." )
   raise SystemExit( 1 )
