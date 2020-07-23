#!/bin/sh

install() {

	cat "${installToolsPath}/PackageListAPT.txt" | xargs sudo apt-get install -y || exit 1

	sudo pip3 install -r "${installToolsPath}/PackageListPython.txt" || exit 1

}

upgrade() {

	sudo apt-get upgrade

	cat "${installToolsPath}/PackageListAPT.txt" | xargs sudo apt-get upgrade -y || exit 1

	sudo pip3 install -r "${installToolsPath}/PackageListPython.txt" --upgrade || exit 1

}

set -o nounset

installToolsPath="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"

if [ "${1}" = "--upgrade" ] || [ "${1}" = "-u" ]; then
	upgrade
elif [ -z "${1}" ]; then
	install
else
	echo "error: Invalid argument. Use '--upgrade' switch to upgrade packages, or none to install packages."
	exit 1
fi

exit 0

