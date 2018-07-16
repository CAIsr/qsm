#!/usr/bin/env bash

imageName='tgvqsm_fsl_5p0p11'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade
#or
#pip install --no-cache-dir https://github.com/stebo85/neurodocker/tarball/master --upgrade



neurodocker generate docker \
   --base=debian:wheezy \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir /90days /30days /QRISdata /RDS /data /short /proc_temp /TMPDIR /nvme /local /gpfs1" \
   --run="locale-gen en_US.UTF-8" \
   --run="dpkg-reconfigure locales" \
   --install apt_opts='--quiet' python-setuptools wget unzip python3 python-numpy python-nibabel cython libdbus-glib-1-2 libjpeg62 libgtk2.0-0 libpng12-0 \
   --workdir /\
   --run "wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip" \
   --run "unzip /TGVQSM-plus.zip" \
   --workdir /TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3 \
   --run "python setup.py install" \
   --dcm2niix version=latest method=source \
   --fsl version=5.0.11 \
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

