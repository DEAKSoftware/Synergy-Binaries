#!/bin/bash

upstreamURL="https://github.com/DEAKSoftware/Synergy-Binaries.git"
queriedURL="$( git config --get remote.origin.url )"

if [ "${upstreamURL}" != "${queriedURL}" ]; then

	echo "error: Unexpected Git upstream URL. This script must run within the repository top-level directory."
	exit 1

fi

toplevelPath="$( git rev-parse --show-toplevel )"
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

buildAppImage() {

	pushd "${toolsPath}" || exit 1

		wget -O linuxdeploy -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage || exit 1
		chmod a+x linuxdeploy || exit 1

		# Needed by linuxdeploy
		export VERSION="${synergyVersion}-${linuxVersion}"

		appImagePath="${buildPath}/Synergy-${VERSION}.AppDir"

		./linuxdeploy \
			--appdir "${appImagePath}" \
			--executable "${buildPath}/bin/synergy" \
			--executable "${buildPath}/bin/synergyc" \
			--executable "${buildPath}/bin/synergyd" \
			--executable "${buildPath}/bin/synergys" \
			--executable "${buildPath}/bin/syntool" \
			--create-desktop-file \
			--icon-file "${synergyCorePath}/res/synergy.svg" \
			--output appimage || exit 1

		mv "${toolsPath}/"*.AppImage "${binariesPath}"

	popd

}

buildDeb() {

	pushd "${synergyCorePath}" || exit 1

		printf "synergy (${synergyVersion}) ${synergyVersionStage}; urgency=medium\n" > "debian/changelog" || exit 1
		debuild --set-envvar CMAKE_BUILD_TYPE=MINSIZEREL --set-envvar SYNERGY_ENTERPRISE=ON -us -uc || exit 1
		git clean -fd

	popd

	mv "${synergyCorePath}/../"*.deb "${binariesPath}"

	rename "s/(\\d+\\.\\d+.\\d+)/\$1-${linuxVersion}/g" "${binariesPath}"/*.deb

	mv "${synergyCorePath}/../synergy_${synergyVersion}"* "${buildPath}"
	mv "${synergyCorePath}/../synergy-dbgsym_${synergyVersion}"* "${buildPath}"

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

	echo \
"NAME

	${0} - Build Linux Binaries for Synergy

SYNOPSIS

	${0} [OPTION]

DESCRIPTION

	This is a utility script for building Synergy binaries and distribution packages.
	The script will build the latest snapshot from the Synergy-Core submodule.

	-h, --help

		Display this help message.

	--cmake

		Build binaries only with CMake.

	--appimage

		Build an AppImage package.

	--deb

		Build a Debian package.

	--all

		Build all packages.

	--clean

		Clean the build and output locations."

	exit 0

elif [ "${1}" = "--cmake" ]; then

	configure
	buildCMake

elif [ "${1}" = "--appimage" ]; then

	configure
	buildCMake
	buildAppImage

elif [ "${1}" = "--deb" ]; then

	configure
	buildDeb

elif [ "${1}" = "--all" ]; then

	configure
	buildCMake
	buildAppImage
	buildDeb

elif [ "${1}" = "--clean" ]; then

	buildClean

else

	echo "error: Bad or unknown option. Run with '--help' option for details."
	exit 1

fi