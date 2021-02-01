#!/usr/bin/env bash
set -e

export toolName='qsmxtbase'
export toolVersion='1.0.0'

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug="true"
fi

source ../main_setup.sh

# this should fix the octave bug caused by fsl installing openblas:
# apt update
# apt install liblapack-dev liblas-dev
# update-alternatives --set libblas.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/blas/libblas.so.3
# update-alternatives --set liblapack.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3


neurodocker generate ${neurodocker_buildMode} \
   --base ubuntu:18.04 \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir -p ${mountPointList}" \
   --install apt_opts="--quiet" wget unzip gcc dbus-x11 libgtk2.0-0 git graphviz wget zip libgl1 libglib2.0 libglu1-mesa libsm6 libxrender1 libxt6 libxcomposite1 libfreetype6 libasound2 libfontconfig1 libxkbcommon0 libxcursor1 libxi6 libxrandr2 libxtst6 qt5-default libqt5svg5-dev wget libqt5opengl5-dev libqt5opengl5 libqt5gui5 libqt5core5a \
   --run="wget https://repo.anaconda.com/miniconda/Miniconda2-4.6.14-Linux-x86_64.sh" \
   --env PATH=/miniconda2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
   --run="bash Miniconda2-4.6.14-Linux-x86_64.sh -b -p /miniconda2/" \
   --run="/miniconda2/bin/conda install -c anaconda cython==0.29.14" \
   --run="/miniconda2/bin/conda install numpy" \
   --run="/miniconda2/bin/conda install pyparsing" \
   --run="/miniconda2/bin/pip install scipy==0.17.1 nibabel==2.1.0" \
   --run="wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip" \
   --run="unzip TGVQSM-plus.zip" \
   --workdir="/TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3" \
   --copy setup.py /TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3 \
   --copy qsm_tgv_cython.py /TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3/TGV_QSM \
   --env PYTHONPATH=/TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3/TGV_QSM \
   --run="/miniconda2/bin/python setup.py install" \
   --workdir="/opt/tgvqsm-1.0.0" \
   --run="cp /miniconda2/bin/tgv_qsm ." \
   --fsl version=6.0.4 exclude_paths='data' \
   --freesurfer version=7.1.1 \
   --copy fs.txt /opt/freesurfer-7.1.1/license.txt \
   --env SUBJECTS_DIR=/tmp \
   --minc version=1.9.17 \
   --dcm2niix method=source version=latest \
   --miniconda use_env=base \
            conda_install='python=3.6 traits nipype' \
            pip_install='bidscoin' \
   --workdir /opt/bru2 \
   --run="conda install -c conda-forge dicomifier" \
   --run="wget https://github.com/neurolabusc/Bru2Nii/releases/download/v1.0.20180303/Bru2_Linux.zip" \
   --run="unzip Bru2_Linux.zip" \
    --install apt_opts="--quiet" liblapack-dev liblas-dev \
   --run="update-alternatives --set libblas.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/blas/libblas.so.3" \
   --run="update-alternatives --set liblapack.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3" \
  > ${imageName}.Dockerfile

if [ "$debug" = "true" ]; then
   ./../main_build.sh
fi
