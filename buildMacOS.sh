#!/bin/bash

# Path to the Qt library, clang, 64-bit build.
libQtPath="~/Qt5.12.9/5.12.9/clang_64"

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

configureQt() {

	export PATH="${libQtPath}:$PATH"

}

configureCMake() {

	cmake -S "${synergyCorePath}" -B "${buildPath}" \
		-D CMAKE_OSX_DEPLOYMENT_TARGET=10.12 \
		-D CMAKE_OSX_ARCHITECTURES=x86_64 \
		-D CMAKE_BUILD_TYPE=Release \
		-D CMAKE_CONFIGURATION_TYPES=Release \
		-D SYNERGY_ENTERPRISE=ON || exit 1

}

configureVersion() {

	source "${buildPath}/version"
	synergyVersion="${SYNERGY_VERSION_MAJOR}.${SYNERGY_VERSION_MINOR}.${SYNERGY_VERSION_PATCH}"
	synergyReleaseName="synergy-${synergyVersion}-macos-x64"

}

configure() {

	configureSubmodules
	configureQt
	configureCMake
	configureVersion
}

buildApp() {

	pushd "${buildPath}" || exit 1

		make -j || exit 1
		make install/strip || exit 1

		macdeployqt "${buildPath}/bundle/Synergy.app" 

		cp -R "${buildPath}/bundle/Synergy.app" "${binariesPath}"

	popd

}

buildDMG() {

	ln -s /Applications "${buildPath}/bundle/Applications"

	hdiutil create -volname "Synergy ${synergyVersion}" -srcfolder "${buildPath}/bundle" -ov -format UDBZ "${binariesPath}/${synergyReleaseName}.dmg" || exit 1

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

elif [ "${1}" = "--app" ]; then

	configure
	buildApp

elif [ "${1}" = "--dmg" ]; then

	configure
	buildDMG

elif [ "${1}" = "--all" ]; then

	configure
	buildApp
	buildDMG

elif [ "${1}" = "--clean" ]; then

	buildClean

else

	echo "error: Bad or unknown option. Run with '--help' option for details."
	exit 1

fi

exit 0
