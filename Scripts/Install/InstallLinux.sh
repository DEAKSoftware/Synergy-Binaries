#!/bin/sh

install() {

   xargs sudo apt-get install -y < "${installToolsPath}/PackageListAPT.txt" || exit 1

	sudo pip3 install -r "${installToolsPath}/PackageListPython.txt" || exit 1

}

upgrade() {

	sudo apt-get update

   xargs sudo apt-get upgrade -y < "${installToolsPath}/PackageListAPT.txt" || exit 1

	sudo pip3 install -r "${installToolsPath}/PackageListPython.txt" --upgrade || exit 1

}

set -o nounset

installToolsPath="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"

if [ "${1-}" = "--upgrade" ]; then
	upgrade
elif [ -z "${1-}" ]; then
	install
else
	echo "error: Invalid argument. Use '--upgrade' switch to upgrade packages, or none to install packages."
	exit 1
fi

exit 0

