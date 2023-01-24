#!/bin/bash

configureCMake() {

   cmake -S "${productRepoPath}" -B "${productBuildPath}" \
      -D CMAKE_BUILD_TYPE=Release \
      -D SYNERGY_ENTERPRISE=ON \
      -D SYNERGY_REVISION="${productRevision}" \
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

      mv "${toolsPath}/"*.AppImage "${binariesPath}/${productPackageName}.AppImage"

   popd

}

buildDeb() {

   pushd "${productRepoPath}" || exit 1

      if [ ! -f "./debian/changelog" ]; then

         # Make a lowercase package name to comply with 
         # Debian changelog formatting requirements.
         packageName=$( echo "${productName}" | tr "[:upper:]" "[:lower:]" )

         # Create a changelog file.
         dch --create --controlmaint --distribution unstable \
            --package "${packageName}" \
            --newversion "${productVersion}" \
            "Snapshot release." \
            || exit 1

      fi

      debuild \
         --preserve-envvar SYNERGY_* \
         --set-envvar CMAKE_BUILD_TYPE=Release \
         --set-envvar SYNERGY_ENTERPRISE=ON \
         --set-envvar DEB_BUILD_OPTIONS="parallel=8" \
         -us -uc \
         || exit 1

      git clean -fd

   popd

   mv "${productRepoPath}/../"*.deb "${binariesPath}/${productPackageName}.deb"
   mv "${productRepoPath}/../synergy_${productVersion}"* "${productBuildPath}"
   mv "${productRepoPath}/../synergy-dbgsym_${productVersion}"* "${productBuildPath}"

}

buildRPM() {

   # rpmbuild is very flaky with paths containing spaces,
   # so we set up a temporary build path and make sure no spaces
   # are present in any paths.
   temporaryPath=$( mktemp -d -t "${productPackageName}-XXXXXXXX" )

   if [[ ! "${temporaryPath}" || ! -d "${temporaryPath}" ]]; then
      print "error: Failed to create temporary path."
      exit 1
   fi

   trap "{ rm -fR '${temporaryPath}'; }" EXIT

   printf "Created temporary path:\n\t${temporaryPath}\n"

   # We will symlink RPM build paths to our temporary location
   # and we'll do work in there.
   rpmToplevelPath="${temporaryPath}/rpm"

   ln -s "${productBuildPath}/rpm" "${rpmToplevelPath}" || exit 1

   rpmBuildrootPath="${rpmToplevelPath}/BUILDROOT"
   installPath="${rpmBuildrootPath}/usr"

   if [[ ${rpmToplevelPath} = *" "* ]]; then
      printf "error: RPM top-level path contained spaces:\n\t${rpmToplevelPath}\n"
      exit 1
   fi

   # Reconfigure with new install path
   cmake -S "${productRepoPath}" -B "${productBuildPath}" \
      -D CMAKE_BUILD_TYPE=Release \
      -D SYNERGY_ENTERPRISE=ON \
      -D SYNERGY_REVISION="${productRevision}" \
      -D CMAKE_INSTALL_PREFIX:PATH="${installPath}" \
      || exit 1

   # Rebuild and deploy to install path
   pushd "${productBuildPath}" || exit 1

      make -j || exit 1
      make install/strip || exit 1

   popd

   # Remove "synergy-core" from "BUILDROOT", as it's not part of the "synergy.spec" file list. Otherwise, 
   # the extra file will cause rpmbuild to emit "Installed (but unpackaged) file(s) found" errors. Hopefully 
   # Synergy devs will fix this problem in the future and the following hack won't be needed.
   rm "${rpmBuildrootPath}/usr/bin/synergy-core"

   pushd "${rpmToplevelPath}" || exit 1

      rpmbuild -bb \
         --define "_topdir ${rpmToplevelPath}" \
         --buildroot "${rpmBuildrootPath}" \
         synergy.spec \
         || exit 1

      mv "RPMS/"*.rpm "${binariesPath}/${productPackageName}.rpm" || exit 1

   popd

}

set -o nounset
# set -o xtrace

configureCMake
buildBinaries
buildAppImage
buildDeb
buildRPM

exit 0
