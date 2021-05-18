#!/usr/bin/env bash
set -e

export toolName='qsmxt'
export toolVersion='1.1.0'

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug="true"
fi

source ../main_setup.sh

# ubuntu:18.04 
# docker.pkg.github.com/neurodesk/caid/qsmxtbase_1.1.0:20210512
# vnmd/qsmxtbase_1.0.0:20210203

neurodocker generate ${neurodocker_buildMode} \
   --base docker.pkg.github.com/neurodesk/caid/qsmxtbase_1.1.0:20210518 \
   --pkg-manager apt \
   --run="mkdir -p ${mountPointList}" \
   --workdir /opt \
   --run="git clone --depth 1 --branch 210506 https://github.com/QSMxT/QSMxT" \
   --env PATH='$PATH':/opt/bru2 \
   --env PATH='$PATH':/opt/FastSurfer \
   --env DEPLOY_PATH=/opt/fsl-6.0.4/bin/ \
   --env DEPLOY_BINS=dcm2niix:bidsmapper:bidscoiner:bidseditor:bidsparticipants:bidstrainer:deface:dicomsort:pydeface:rawmapper:Bru2:Bru2Nii:tgv_qsm:julia  \
   --env PYTHONPATH=/opt/QSMxT:/TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3/TGV_QSM \
   --run="cp /opt/QSMxT/README.md /README.md" \
  > ${imageName}.Dockerfile

if [ "$debug" = "true" ]; then
   ./../main_build.sh
fi