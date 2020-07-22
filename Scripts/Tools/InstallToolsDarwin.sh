#!/bin/sh

scriptPath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

xcode-select --install

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install python git cmake libsodium openssl

sudo pip3 install -r "${scriptPath}/ToolRequirements.txt"
