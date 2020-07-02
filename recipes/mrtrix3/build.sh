#!/usr/bin/env bash
set -e

export toolName='mrtrix3'
export toolVersion='3.0.0'

source ../main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base vnmd/fsl_6.0.1:20200702 \
   --pkg-manager apt \
   --${toolName} version=${toolVersion} method="source" \
   --ants version="2.3.4" \
   --env DEPLOY_PATH=/opt/${toolName}-${toolVersion}/bin/ \
   --user=neuro \
  > ${imageName}.Dockerfile
