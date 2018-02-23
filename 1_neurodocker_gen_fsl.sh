
#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade

neurodocker generate \
	--base neurodebian:stretch-non-free \
	--pkg-manager apt \
	--fsl version=5.0.10 \
	--user=neuro \
	--workdir /home/neuro \
	--no-check-urls \
	> Dockerfile_fsl
