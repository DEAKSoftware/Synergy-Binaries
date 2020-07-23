#!/usr/bin/env python3

import os, platform, sys

assert sys.version_info >= ( 3, 8 )

from Detail.Config import config
import Detail.Utility as utility

def configureSubmodules():

   utility.printHeading( "Updating Git submodules..." )

   os.chdir( config.toplevelPath )

   statusBefore = utility.captureCommandOutput( "git submodule status" )
   print( statusBefore )

   utility.runCommand( "git submodule update --init --remote --recursive" )

   statusAfter = utility.captureCommandOutput( "git submodule status" )
   print( statusAfter )

   if statusBefore != statusAfter:
      utility.printHeading( "Updating product version..." )
      config.updateProductVersion()

def configureEnvironment():

   utility.printHeading( "Configuring environment..." )

   variables = config.variableList()

   variables[ "isConfigured" ] = "1"

   for name, value in variables.items():

      if value:
         print( "\tSetting: ${" + utility.style.bold + name + utility.style.none + "}" )
         os.environ[ name ] = value
      else:
         print( "\tUnused: " + utility.style.error + name + utility.style.none )

def buildProducts():

   utility.printHeading( "Building products..." )

   scripts = {
      "Darwin"  : "Scripts/Build/BuildDarwin.sh",
      "Linux"   : "Scripts/Build/BuildLinux.sh",
      "Windows" : "Scripts/Build/BuildWindows.cmd",
      }

   scriptPath = utility.joinPath( config.toplevelPath, scripts[ platform.system() ] )

   utility.runCommand( '"' + scriptPath + '"' )

configureSubmodules()

configureEnvironment()

# buildProducts()
