#!/bin/sh

scriptPath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

sudo apt-get update

sudo apt-get install -y build-essential python3 python3-pip python3-setuptools git cmake build-essential devscripts alien

sudo pip3 install -r "${scriptPath}/ToolRequirements.txt"
