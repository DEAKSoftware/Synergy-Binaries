#!/usr/bin/env python3

# import clean

import Detail.Build# as build

b = Detail.Build.BuildSystem()

b.configure()
b.make()
