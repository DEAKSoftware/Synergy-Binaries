#!/bin/bash

# upstreamURL="https://github.com/DEAKSoftware/Synergy-Binaries.git"
# queriedURL="$( git config --get remote.origin.url )"
# toplevelPath="$( git rev-parse --show-toplevel )"

# if [ "${upstreamURL}" != "${queriedURL}" ] || [ "${toplevelPath}" == "" ]; then

# 	echo "error: Unrecognised Git upstream URL, or top-level directory. This script must run within the top-level directory of the Synergy-Binaries repository."
# 	exit 1

# fi

# productRepoPath="${toplevelPath}/Synergy-Core"
# buildPath="${productRepoPath}/build"
# binariesPath="${toplevelPath}/Binaries"
# toolsPath="${toplevelPath}/Tools"


# configureSubmodules() {

# 	git submodule update --init --remote --recursive

# }

# configureCMake() {

# 	cmake -S "${productRepoPath}" -B "${buildPath}" -D CMAKE_BUILD_TYPE=MINSIZEREL -D SYNERGY_ENTERPRISE=ON || exit 1

# }

# configureVersion() {

# 	source /etc/os-release || exit 1
# 	linuxVersion="${ID}${VERSION_ID}"

# 	source "${buildPath}/version"
# 	synergyVersion="${SYNERGY_VERSION_MAJOR}.${SYNERGY_VERSION_MINOR}.${SYNERGY_VERSION_PATCH}"
# 	synergyVersionStage="${SYNERGY_VERSION_STAGE}"

# }

# configure() {

# 	configureSubmodules
# 	configureCMake
# 	configureVersion
# }


# buildBinaries() {

# 	cmake --build "${buildPath}" --parallel 8 || exit 1

# }

# buildAppImage() {

# 	pushd "${toolsPath}" || exit 1

# 		wget -O linuxdeploy -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage || exit 1
# 		chmod a+x linuxdeploy || exit 1

# 		# Needed by linuxdeploy
# 		export VERSION="${synergyVersion}-${linuxVersion}"

# 		appImagePath="${buildPath}/Synergy-${VERSION}.AppDir"

# 		./linuxdeploy \
# 			--appdir "${appImagePath}" \
# 			--executable "${buildPath}/bin/synergy" \
# 			--executable "${buildPath}/bin/synergyc" \
# 			--executable "${buildPath}/bin/synergyd" \
# 			--executable "${buildPath}/bin/synergys" \
# 			--executable "${buildPath}/bin/syntool" \
# 			--create-desktop-file \
# 			--icon-file "${productRepoPath}/res/synergy.svg" \
# 			--output appimage || exit 1

# 		mv "${toolsPath}/"*.AppImage "${binariesPath}"

# 	popd

# }

# buildDeb() {

# 	pushd "${productRepoPath}" || exit 1

# 		printf "synergy (${synergyVersion}) ${synergyVersionStage}; urgency=medium\n" > "debian/changelog" || exit 1
# 		debuild --set-envvar CMAKE_BUILD_TYPE=MINSIZEREL --set-envvar SYNERGY_ENTERPRISE=ON -us -uc || exit 1
# 		git clean -fd

# 	popd

# 	mv "${productRepoPath}/../"*.deb "${binariesPath}"

# 	rename "s/(\\d+\\.\\d+.\\d+)/\$1-${linuxVersion}/g" "${binariesPath}"/*.deb

# 	mv "${productRepoPath}/../synergy_${synergyVersion}"* "${buildPath}"
# 	mv "${productRepoPath}/../synergy-dbgsym_${synergyVersion}"* "${buildPath}"

# }

# buildClean() {

# 	pushd "${productRepoPath}" || exit 1

# 		git clean -fdx

# 	popd

# 	pushd "${toplevelPath}" || exit 1

# 		git clean -fdx

# 	popd

# }

# if [ "${1}" = "--help" ] || [ "${1}" = "-h" ]; then

# 	cat "${toplevelPath}/Documentation/HelpLinux.txt"

# elif [ "${1}" = "--bin" ]; then

# 	configure
# 	buildBinaries

# elif [ "${1}" = "--appimage" ]; then

# 	configure
# 	buildBinaries
# 	buildAppImage

# elif [ "${1}" = "--deb" ]; then

# 	configure
# 	buildDeb

# elif [ "${1}" = "--all" ]; then

# 	configure
# 	buildBinaries
# 	buildAppImage
# 	buildDeb

# elif [ "${1}" = "--clean" ]; then

# 	buildClean

# else

# 	echo "error: Bad or unknown option. Run with '--help' option for details."
# 	exit 1

# fi

# exit 0

configureCMake() {

	cmake -S "${productRepoPath}" -B "${productBuildPath}" \
		-D CMAKE_BUILD_TYPE=Release \
		-D SYNERGY_ENTERPRISE=ON \
		|| exit 1

}

buildBinaries() {

	cmake --build "${productBuildPath}" --parallel || exit 1

}

buildAppImage() {

	pushd "${toolsPath}" || exit 1

		wget -O linuxdeploy -c "${linuxdeployURL}" || exit 1
		chmod a+x linuxdeploy || exit 1

		# Needed by linuxdeploy
		export VERSION="${productVersion}-${productStage}"

		appImagePath="${productBuildPath}/${productPackageName}.AppDir"

		./linuxdeploy \
			--appdir "${appImagePath}" \
			--executable "${productBuildPath}/bin/synergy" \
			--executable "${productBuildPath}/bin/synergyc" \
			--executable "${productBuildPath}/bin/synergyd" \
			--executable "${productBuildPath}/bin/synergys" \
			--executable "${productBuildPath}/bin/syntool" \
			--create-desktop-file \
			--icon-file "${productRepoPath}/res/synergy.svg" \
			--output appimage || exit 1

		rsync -a --delete "${toolsPath}/"*.AppImage "${binariesPath}/${productPackageName}.AppImage"

	popd

}

set -o nounset

configureCMake
buildBinaries
buildAppImage

exit 0
