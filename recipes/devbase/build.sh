#!/usr/bin/env bash
set -e

export toolName='devbase'
export toolVersion='1.0.0'

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug="true"
fi

source ../main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base ubuntu:18.04 \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir -p ${mountPointList}" \
   --install apt_opts="--quiet" wget unzip gcc \
   --run="wget https://repo.anaconda.com/miniconda/Miniconda2-4.6.14-Linux-x86_64.sh" \
   --env PATH=/miniconda2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
   --run="bash Miniconda2-4.6.14-Linux-x86_64.sh -b -p /miniconda2/" \
   --run="/miniconda2/bin/conda install -c anaconda cython==0.25.2" \
   --run="/miniconda2/bin/conda install numpy" \
   --run="/miniconda2/bin/conda install pyparsing" \
   --run="/miniconda2/bin/pip install scipy==0.17.1 nibabel==2.1.0" \
   --run="wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip" \
   --run="unzip TGVQSM-plus.zip" \
   --workdir="/TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3" \
   --run="/miniconda2/bin/python setup.py install" \
   --workdir="/opt/tgvqsm-1.0.0" \
   --run="cp /miniconda2/bin/tgv_qsm ." \
   --freesurfer version=6.0.0-min \
   --env FS_LICENSE=~/license.txt \
   --install dbus-x11 \
   --fsl version=6.0.1 \
   --minc version=1.9.17 \
   --workdir /opt \
   --install git python3-tk python3-numpy python3-setuptools python3-pip python3-dev zlib1g-dev libzstd1 graphviz \
   --dcm2niix method=source version=latest \
  > ${imageName}.Dockerfile

if [ "$debug" = "true" ]; then
   ./../main_build.sh
fi
