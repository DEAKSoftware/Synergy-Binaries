#!/bin/bash

scriptPath="$( cd "$(dirname "${0}")" ; pwd -P )"
buildPath="${scriptPath}/Build"
binariesPath="${scriptPath}/Binaries"
synergyCorePath="${scriptPath}/Synergy-Core"

source /etc/os-release || exit 1
cat "${synergyCorePath}/Build.properties" | perl -pe "s/(SYNERGY\w+) *= */export \1=/" > "${buildPath}/version"
source "${buildPath}/version" || exit 1

linuxVersion="${ID}-${VERSION_CODENAME}"
synergyVersion="${SYNERGY_VERSION_MAJOR}.${SYNERGY_VERSION_MINOR}.${SYNERGY_VERSION_PATCH}"

buildCMake() {

	pushd "${buildPath}" || exit 1

		cmake -S "${synergyCorePath}" -B "${buildPath}" -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON || exit 1
		cmake --build "${buildPath}" --parallel 8 || exit 1

	popd
}

buildAppImage() {

	pushd "${buildPath}" || exit 1

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

		mv "${buildPath}/"*.AppImage "${binariesPath}"

	popd
}

buildDeb() {

	pushd "${buildPath}" || exit 1

		pushd "${synergyCorePath}" || exit 1

			printf "synergy (${synergyVersion}) ${synergyStage}; urgency=medium\n" > "debian/changelog"
			debuild --set-envvar CMAKE_BUILD_TYPE=MINSIZEREL --set-envvar SYNERGY_ENTERPRISE=ON -us -uc
			git clean -fd

		popd

		mv "${synergyCorePath}/../"*.deb "${binariesPath}"
		rm "${synergyCorePath}/../synergy_${synergyVersion}"*
		rm "${synergyCorePath}/../synergy-dbgsym_${synergyVersion}"*

	popd
}

buildClean() {

	rm -fR "${buildPath}/"*
	rm -fR "${binariesPath}/"*

	touch "${buildPath}/.keep"
	touch "${binariesPath}/.keep"

}


if [ "${1}" = "--help" ] || [ "${1}" = "-h" ]; then

	echo \
"NAME

	${0} - Build Linux Binaries for Synergy

SYNOPSIS

	${0} [OPTION]

DESCRIPTION

	Synergy is a keyboard and mouse sharing tool for devices connected over a network.
	The official maintainers of Synergy no longer publish binaries without users paying for it.
	Therefore, your alternative is to build Synergy yourself. This tool will help you do that.

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

		Clean the Build and Binaries output."

	exit 0

elif [ "${1}" = "--cmake" ]; then

	buildCMake

elif [ "${1}" = "--appimage" ]; then

	buildCMake # Prerequisite for an AppImage
	buildAppImage

elif [ "${1}" = "--deb" ]; then

	buildDeb

elif [ "${1}" = "--all" ]; then

	buildCMake
	buildAppImage
	buildDeb

elif [ "${1}" = "--clean" ]; then

	buildClean

else

	echo "error: Bad or unknown option. Run with '--help' option for details."
	exit 1

fi