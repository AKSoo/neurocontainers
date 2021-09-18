#!/usr/bin/env bash
set -e

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug="true"
fi

export toolName='freesurfer'
export toolVersion=6.0.0
# Don't forget to update version change in README.md!!!!!

source ../main_setup.sh

# I applied for the freesurfer license for 400 users. When he hit tha many users, we need to renew the license!

neurodocker generate ${neurodocker_buildMode} \
   --base-image ubuntu:16.04 \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --${toolName} version=${toolVersion} \
   --install dbus-x11 \
   --env DEPLOY_PATH=/opt/${toolName}-${toolVersion}/bin/ \
   --copy license.txt /opt/freesurfer-6.0.0/license.txt \
   --copy README.md /README.md \
   --user=neuro \
  > ${imageName}.${neurodocker_buildExt}

if [ "$debug" = "true" ]; then
   ./../main_build.sh
fi
