#!/usr/bin/env bash
set -e

export toolName='minc'
export toolVersion='master'

source main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base debian:stretch \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --${toolName} version=${toolVersion} method=source \
   --env DEPLOY_PATH=/opt/${toolName}-${toolVersion}/bin/ \
   --user=neuro \
  > recipe.${imageName}

./main_build.sh
