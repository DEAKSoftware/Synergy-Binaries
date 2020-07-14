#!/bin/bash

scriptPath="$( cd "$(dirname "${0}")" ; pwd -P )"
buildPath="${scriptPath}/Build"
synergyCorePath="${scriptPath}/Synergy-Core"


mkdir "${buildPath}"; cd "${buildPath}"


cmake -S "${synergyCorePath}" -B "${buildPath}"

# pushd "${synergyCorePath}"

cmake --build "${buildPath}" --parallel 8

# popd







# pushd "${synergyCorePath}"

# 	source "build/version"

# 	versionString="${SYNERGY_VERSION_MAJOR}.${SYNERGY_VERSION_MINOR}.${SYNERGY_VERSION_PATCH}"

# 	echo "synergy (${versionString}) ${SYNERGY_VERSION_STAGE}; urgency=medium" > "debian/changelog"

# 	debuild --set-envvar SYNERGY_ENTERPRISE=ON -us -uc

# 	git clean -fd

# popd

