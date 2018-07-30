#!/usr/bin/env bash
set -e

imageName='tgvqsm_fsl_5p0p11'
buildDate=`date +%Y%m%d`


buildPlatform=`cat /proc/cpuinfo | grep 'vendor' | uniq | cut -d ' ' -f 2`

echo $buildPlatform

if [ "$buildPlatform" = "AuthenticAMD" ]; then
   echo "detected amd"
   export buildPlatform='amd'
 fi

 if [ "$buildPlatform" = "GenuineIntel" ]; then
   echo "detected intel"
   export buildPlatform='intel'
 fi

imageName=${imageName}_${buildPlatform}


echo "building $imageName"


#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade
#or
#pip install --no-cache-dir https://github.com/stebo85/neurodocker/tarball/master --upgrade


neurodocker generate docker \
   --base=neurodebian:jessie \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --copy globalMountPointList.txt /globalMountPointList.txt \
   --run="mkdir \`cat /globalMountPointList.txt\`" \
   --install apt_opts='--quiet' python-setuptools wget unzip python3 python-numpy python-nibabel cython \
   --dcm2niix version=latest method=source \
   --workdir /\
   --run "wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip" \
   --run "unzip /TGVQSM-plus.zip" \
   --workdir /TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3 \
   --run "python setup.py install" \
   --fsl version=5.0.11 \
   --env DEPLOY_PATH=/usr/local/bin/:/opt/dcm2niix-latest/bin:/opt/fsl-5.0.11/bin/ \
   --user=neuro \
   > Dockerfile.${imageName}



docker build -t ${imageName}:$buildDate -f  Dockerfile.${imageName} .

#test:
docker run -it ${imageName}:$buildDate
#exit 0





docker tag ${imageName}:$buildDate caid/${imageName}:$buildDate
#docker login
docker push caid/${imageName}:$buildDate
docker tag ${imageName}:$buildDate caid/${imageName}:latest
docker push caid/${imageName}:latest

echo "BootStrap:docker" > Singularity.${imageName}
echo "From:caid/${imageName}" >> Singularity.${imageName}

rm ${imageName}_${buildDate}.simg
sudo singularity build ${imageName}_${buildDate}.simg Singularity.${imageName}

source ../setupSwift.sh
swift upload singularityImages ${imageName}_${buildDate}.simg

git commit -am 'auto commit after build run'
git push
