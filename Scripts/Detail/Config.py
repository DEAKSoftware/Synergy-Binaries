#!/bin/echo "This module must be imported by other Python scripts."

import argparse, configparser, os, platform, re, sys

import Detail.Utility as utility

assert sys.version_info >= ( 3, 8 )

class Configuration():

   upstreamURL  = ""
   toplevelPath = ""
   binariesPath = ""
   toolsPath    = ""

   libQtPath      = ""
   vcvarsallPath  = ""
   cmakeGenerator = ""
   linuxdeployURL = ""

   platformVersion = ""

   productName        = "Synergy"
   productVersion     = "unknown-version"
   productStage       = "snapshot"
   productRevision    = "0"
   productPackageName = "-".join( [ productName, productVersion, productStage ] ).lower()
   productRepoPath    = ""
   productBuildPath   = ""
   productCheckout    = ""

   # Constructor

   def __init__( self, configPath ):

      def programOptions( self ):

         parser = argparse.ArgumentParser( description =
            "This utility builds the Synergy-Core binaries. The product version is extracted from the most recent Git tag. One can also build older versions "
            "by checking out specific git tags, see options below." )

         parser.add_argument( "--checkout", dest = "productCheckout", help = "Checkout and build a specific Git tag (or commit hash) for the Synergy-Core submodule." )

         for key, value in vars( parser.parse_args() ).items():
            setattr( self, key, value )

      def loadConfiguration( self, configPath ):

         utility.printItem( "configPath: ", configPath )

         parser = configparser.ConfigParser(
            dict_type = dict,
            allow_no_value = True,
            default_section = "All" )

         parser.read( configPath )

         section = platform.system()

         for name in self.propertyList():
            value = parser.get( section, name, fallback = getattr( self, name ) )
            setattr( self, name, value )

      def validateToplevelPath( self ):

         queriedURL = utility.captureCommandOutput( "git config --get remote.origin.url" )

         self.toplevelPath = utility.captureCommandOutput( "git rev-parse --show-toplevel" )

         utility.printItem( "toplevelPath: ", self.toplevelPath )
         utility.printItem( "upstreamURL: ", self.upstreamURL )
         utility.printItem( "queriedURL: ", queriedURL )

         if not os.path.exists( self.toplevelPath ):
            utility.printError( "Git top level path does not exist:\n\t", self.toplevelPath )
            raise SystemExit( 1 )

         if queriedURL != self.upstreamURL:
            utility.printError( "The upstream URL at the current working directory does not match project upstream URL:\n\t", queriedURL )
            raise SystemExit( 1 )

      def validateConfigurationPaths( self ):

         def resolvePath( self, name, mustExist = True ):

            path = getattr( self, name )
            if not path: return

            path = utility.joinPath( self.toplevelPath, os.path.expanduser( path ) )

            utility.printItem( name + ": ", path )

            if not os.path.exists( path ) and mustExist:
               utility.printError( "Required path does not exist:\n\t", path )
               raise SystemExit( 1 )

            setattr( self, name, path )

         resolvePath( self, "productRepoPath" )
         resolvePath( self, "productBuildPath", mustExist = False )
         resolvePath( self, "binariesPath" )
         resolvePath( self, "toolsPath" )
         resolvePath( self, "libQtPath" )
         resolvePath( self, "vcvarsallPath" )

      def configurePlatformVersion( self ):

         if platform.system() == "Windows":

            self.platformVersion = "-".join( [ platform.system(), platform.release(), platform.machine() ] )

         else:

            import distro # TODO: Move this to global scope when distro supports Windows
            platformInfo = list( distro.linux_distribution( full_distribution_name = False ) )

            while "" in platformInfo:
               platformInfo.remove( "" )

            platformInfo.append( platform.machine() )
            self.platformVersion = "-".join( platformInfo )

         utility.printItem( "platformVersion: ", self.platformVersion )

      def configureProductVersion( self ):

         self.updateProductVersion()

      programOptions( self )

      utility.printHeading( "Loading configuration..." )

      loadConfiguration( self, configPath )

      utility.printHeading( "Git configuration..." )

      validateToplevelPath( self )

      utility.printHeading( "Path configuration..." )

      validateConfigurationPaths( self )

      utility.printHeading( "Version configuration..." )

      configurePlatformVersion( self )
      configureProductVersion( self )

   def updateProductVersion( self ):

      os.chdir( self.productRepoPath )

      lastTag = utility.captureCommandOutput( "git describe --tags --abbrev=0" )

      matches = re.search( "v?(\d+(?:\.\d+)+)-(\w+)", lastTag )

      if not matches:
         utility.printError( "Unable to extract version information from Git tags." )
         raise SystemExit( 1 )

      self.productVersion = matches.group( 1 ) 
      self.productStage = matches.group( 2 )
      self.productRevision = utility.captureCommandOutput( "git rev-parse --short=8 HEAD" )
      self.productPackageName = "-".join( [ self.productName, self.productVersion, self.productStage, self.platformVersion ] ).lower()

      utility.printItem( "productVersion: ", self.productVersion )
      utility.printItem( "productStage: ", self.productStage )
      utility.printItem( "productRevision: ", self.productRevision )
      utility.printItem( "productPackageName: ", self.productPackageName )

      os.chdir( self.toplevelPath )

   # Property list

   def propertyList( self ):

      return dict( ( name, getattr( self, name ) ) for name in dir( self ) if not callable( getattr( self, name ) ) and not name.startswith( '__' ) )

config = Configuration( utility.joinPath( utility.basePathAtSource( __file__ ), "..", "config.txt" ) )
