#!/bin/echo "This module must be imported by other Python scripts."

import os, subprocess, colorama


colorama.init()

# -----------------------------------------------------------------------------
# Text styling and printing utilities.
# -----------------------------------------------------------------------------
class style:
   heading   = '\033[95m'
   info      = '\033[96m'
   success   = '\033[92m'
   warning   = '\033[93m'
   error     = '\033[91m'
   bold      = '\033[1m'
   underline = '\033[4m'
   none      = '\033[0m'

def printHeading( *args, **kwargs ):

   print( style.heading + " ".join( map( str, args ) ) + style.none, **kwargs )

def printInfo( *args, **kwargs ):

   print( style.info + " ".join( map( str, args ) ) + style.none, **kwargs )

def printSuccess( *args, **kwargs ):

   print( style.success + " ".join( map( str, args ) ) + style.none, **kwargs )

def printWarning( *args, **kwargs ):

   print( style.warning + "warning: " + style.none + " ".join( map( str, args ) ), **kwargs )

def printError( *args, **kwargs ):

   print( style.error + "error: " + style.none + " ".join( map( str, args ) ), **kwargs )

def printBold( *args, **kwargs ):

   print( style.bold + " ".join( map( str, args ) ) + style.none, **kwargs )

def printUnderline( *args, **kwargs ):

   print( style.underline + " ".join( map( str, args ) ) + style.none, **kwargs )

def printItem( key, *args, **kwargs ):

   print( style.bold + key  + style.none + " ".join( map( str, args ) ), **kwargs )

# -----------------------------------------------------------------------------
# Command utilities.
# -----------------------------------------------------------------------------
def runCommand( command ):

   print( command )

   completedProcess = subprocess.run( command.split() )

   if completedProcess.returncode != 0:
      printError( "Command exited with error: " + command )
      raise SystemExit( 1 )

def runCommandAndPipeStdout( command ):

   completedProcess = subprocess.run( command.split(), stdout = subprocess.PIPE )

   if completedProcess.returncode != 0:
      printError( "Command exited with error: " + command )
      raise SystemExit( 1 )

   stdoutString = completedProcess.stdout.decode( "utf-8" )

   return stdoutString.rstrip()

# -----------------------------------------------------------------------------
# Path utilities.
# -----------------------------------------------------------------------------
def basePathAtSource( sourceFile ):

   return os.path.dirname( os.path.realpath( sourceFile ) )

def joinPath( component1, component2, *components ):

   return os.path.normpath( os.path.join( component1, component2, *components ) )

# -----------------------------------------------------------------------------
# String utilities.
# -----------------------------------------------------------------------------
def splitDelimitedString( string ):

   return filter( None, set( [ s.strip() for s in string.split( ',' ) ] ) )
