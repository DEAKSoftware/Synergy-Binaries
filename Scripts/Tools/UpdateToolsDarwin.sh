#!/bin/sh

scriptPath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

brew upgrade

sudo pip3 install -r "${scriptPath}/ToolRequirements.txt" --upgrade
