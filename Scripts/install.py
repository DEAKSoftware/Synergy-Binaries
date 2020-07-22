#!/usr/bin/env python3

import os, platform

print( "Installing tools for platform " + platform.system() )

toolsPath = os.path.join( os.path.dirname( os.path.realpath( __file__ ) ), "Tools" )

if ( platform.system() == "Darwin" ):

    command = os.path.join( toolsPath, "InstallToolsDarwin.sh" )
    
    os.system( command )

elif ( platform.system() == "Linux" ):

    command = os.path.join( toolsPath, "InstallToolsLinux.sh" )

    os.system( command )

elif ( platform.system() == "Windows" ):

    command = os.path.join( toolsPath, "InstallToolsWindows.ps1" )

    os.system( "powershell " + command )

else:

    print( "Unrecognised platform: " + platform.system() )
    raise SystemExit( 1 )
