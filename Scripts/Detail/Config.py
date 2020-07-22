#!/bin/echo "This module must be imported by other Python scripts."

import os, platform, configparser

import Detail.Utility as utility

class Configuration( configparser.ConfigParser ):

   # Constructor

   def __init__( self, configPath ):

      defaults = {
         "upstreamURL"        : "",
         "toplevelPath"       : "",
         "synergyCorePath"    : "",
         "synergyBuildPath"   : "",
         "synergyVersionPath" : "",
         "binariesPath"       : "",
         "toolsPath"          : "",
         "libQtPath"          : "",
         "vcvarsallPath"      : "",
         "cmakeGenerator"     : "",
         "linuxdeployURL"     : "",
         }

      super().__init__( dict_type = dict, allow_no_value = True, default_section = "All", defaults = defaults )

      self.read( configPath )

      def validateToplevelPath( config ):

         utility.printHeading( "Git configuration..." )

         section = platform.system();

         upstreamURL  = config[ section ][ "upstreamURL" ]
         queriedURL   = utility.captureCommandOutput( "git config --get remote.origin.url" )
         toplevelPath = utility.captureCommandOutput( "git rev-parse --show-toplevel" )

         utility.printItem( "toplevelPath: ", toplevelPath )
         utility.printItem( "upstreamURL: ", upstreamURL )
         utility.printItem( "queriedURL: ", queriedURL )

         if not os.path.exists( toplevelPath ):
            utility.printError( "Git top level path does not exist:\n\t", toplevelPath )
            raise SystemExit( 1 )

         if queriedURL != upstreamURL:
            utility.printError( "The upstream URL at the current working directory does not match project upstream URL:\n\t", queriedURL )
            raise SystemExit( 1 )

         config[ section ][ "toplevelPath" ] = toplevelPath

      def validateConfigPaths( config ):

         utility.printHeading( "Path configuration..." )

         def resolvePath( config, name, mustExist = True ):

            section = platform.system();
            path = config[ section ][ name ]

            if path != "":
               path = utility.joinPath( config[ section ][ "toplevelPath" ], os.path.expanduser( path ) ) 
               utility.printItem( name + ": ", path )

               if not os.path.exists( path ) and mustExist:
                  utility.printError( "Required path does not exist:\n\t", path )
                  raise SystemExit( 1 )

               config[ section ][ name ] = path

         resolvePath( config, "synergyCorePath" )
         resolvePath( config, "synergyBuildPath", mustExist = False )
         resolvePath( config, "synergyVersionPath", mustExist = False )
         resolvePath( config, "binariesPath" )
         resolvePath( config, "toolsPath" )
         resolvePath( config, "libQtPath" )
         resolvePath( config, "vcvarsallPath" )

      validateToplevelPath( self )
      validateConfigPaths( self )

   # Convenience accessors

   def toplevelPath( self ):

      return self.get(  platform.system(), "toplevelPath" )

   def synergyCorePath( self ):

      return self.get(  platform.system(), "synergyCorePath" )

   def synergyBuildPath( self ):

      return self.get(  platform.system(), "synergyBuildPath" )

   def synergyVersionPath( self ):

      return self.get( platform.system(), "synergyVersionPath" )

   def binariesPath( self ):

      return self.get(  platform.system(), "binariesPath" )

   def toolsPath( self ):

      return self.get(  platform.system(), "toolsPath" )

   def libQtPath( self ):

      return self.get( platform.system(), "libQtPath" )

   def vcvarsallPath( self ):

      return self.get( platform.system(), "vcvarsallPath" )

   def cmakeGenerator( self ):

      return self.get( platform.system(), "cmakeGenerator" )

   def linuxdeployURL( self ):

      return self.get( platform.system(), "linuxdeployURL" )

scriptPath = utility.joinPath( utility.basePathAtSource( __file__ ), ".." )
configPath = utility.joinPath( scriptPath, "config.txt" )

config = Configuration( configPath )
