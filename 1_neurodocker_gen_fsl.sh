
#install neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

neurodocker generate \
	--base ubuntu:17.04 \
	--pkg-manager apt \
	--fsl version=5.0.10 \
	--dcm2niix version='latest' \
	> Dockerfile_fsl
