#!/usr/bin/env python3

import glob, os, platform, re, shutil, sys, tempfile

assert sys.version_info >= ( 3, 8 )

from Detail.Config import config
import Detail.Utility as utility

def configureSubmodules():

   utility.printHeading( "Updating Git submodules..." )

   os.chdir( config.toplevelPath() )

   utility.runCommand( "git submodule update --init --remote --recursive" )


for k, v in config.__dict__.items():
   print( k, "\t", v )

