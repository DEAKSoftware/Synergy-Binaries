#!/usr/bin/env python3

import os

from Detail.Config import config
import Detail.Utility as utility

utility.printHeading( "Cleaning project..." )

os.chdir( config.synergyCorePath() )

utility.runCommand( "git clean -fdx" )

os.chdir( config.toplevelPath() )

utility.runCommand( "git clean -fdx" )
