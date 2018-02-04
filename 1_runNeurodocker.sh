
#install neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

neurodocker generate \
	--base debian:stretch \
	--pkg-manager apt \
	--fsl version=5.0.10 \
	--dcm2niix version='latest' \
	--install wget unzip python3 python-numpy python-nibabel python-setuptools cython \
	--workdir /\
	--run="wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip" \
	--run="unzip /TGVQSM-plus.zip" \
	--workdir /TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3 \
	--run="python3 setup.py install" \
	> Dockerfile_neurodocker
