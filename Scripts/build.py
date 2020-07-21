#!/usr/bin/env python3

# import clean

import Detail.Build

b = Detail.Build.BuildSystem()

b.configure()
b.make()

# b.clean()
