#!/bin/sh

install() {

	sudo xcode-select --install || exit 1

	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit 1

	brew install python git cmake libsodium openssl || exit 1

	sudo pip3 install -r "${installToolsPath}/PackageListPython.txt" || exit 1

}

upgrade() {

	brew upgrade || exit 1

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
