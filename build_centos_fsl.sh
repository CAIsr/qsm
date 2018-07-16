#!/usr/bin/env bash

imageName='centos_fsl_5p0p11'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade
#or
#pip install --no-cache-dir https://github.com/stebo85/neurodocker/tarball/master --upgrade



neurodocker generate docker \
   --base=centos:7 \
   --pkg-manager yum \
   --workdir /\
   --fsl version=5.0.11 \
   --install gtk2 \
   --env FSLOUTPUTTYPE=NIFTI_GZ \
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

