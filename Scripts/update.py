#!/usr/bin/env python3

import os, platform

print( "Updating tools for platform " + platform.system() )

toolsPath = os.path.join( os.path.dirname( os.path.realpath( __file__ ) ), "Tools" )

if ( platform.system() == "Darwin" ):

    command = os.path.join( toolsPath, "UpdateToolsDarwin.sh" )
    
    os.system( command )

elif ( platform.system() == "Linux" ):

    command = os.path.join( toolsPath, "UpdateToolsLinux.sh" )

    os.system( command )

elif ( platform.system() == "Windows" ):

    command = os.path.join( toolsPath, "UpdateToolsWindows.ps1" )

    os.system( "powershell " + command )

else:

    print( "Unrecognised platform: " + platform.system() )
    raise SystemExit( 1 )
