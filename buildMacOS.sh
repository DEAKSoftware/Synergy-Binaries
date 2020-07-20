#!/bin/bash

upstreamURL="https://github.com/DEAKSoftware/Synergy-Binaries.git"
queriedURL="$( git config --get remote.origin.url )"
toplevelPath="$( git rev-parse --show-toplevel )"

if [ "${upstreamURL}" != "${queriedURL}" ] || [ "${toplevelPath}" == "" ]; then

	echo "error: Unrecognised Git upstream URL, or top-level directory. This script must run within the top-level directory of the Synergy-Binaries repository."
	exit 1

fi

synergyCorePath="${toplevelPath}/Synergy-Core"
buildPath="${synergyCorePath}/build"
binariesPath="${toplevelPath}/Binaries"
toolsPath="${toplevelPath}/Tools"


configureSubmodules() {

	git submodule update --init --remote --recursive

}

configureCMake() {

	cmake -S "${synergyCorePath}" -B "${buildPath}" -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON || exit 1

}

configureVersion() {

	source /etc/os-release || exit 1
	linuxVersion="${ID}${VERSION_ID}"

	source "${buildPath}/version"
	synergyVersion="${SYNERGY_VERSION_MAJOR}.${SYNERGY_VERSION_MINOR}.${SYNERGY_VERSION_PATCH}"
	synergyVersionStage="${SYNERGY_VERSION_STAGE}"

}

configure() {

	configureSubmodules
	configureCMake
	configureVersion
}


buildCMake() {

	cmake --build "${buildPath}" --parallel 8 || exit 1

}

buildDMG() {

	echo .

}

buildClean() {

	pushd "${synergyCorePath}" || exit 1

		git clean -fdx

	popd

	pushd "${toplevelPath}" || exit 1

		git clean -fdx

	popd

}

if [ "${1}" = "--help" ] || [ "${1}" = "-h" ]; then

	cat "${toplevelPath}/Documentation/HelpMacOS.txt"

elif [ "${1}" = "--cmake" ]; then

	configure
	buildCMake

elif [ "${1}" = "--dmg" ]; then

	configure
	buildDMG

elif [ "${1}" = "--all" ]; then

	configure
	buildCMake
	buildDMG

elif [ "${1}" = "--clean" ]; then

	buildClean

else

	echo "error: Bad or unknown option. Run with '--help' option for details."
	exit 1

fi

exit 0
