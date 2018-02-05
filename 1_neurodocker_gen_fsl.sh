
#install neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

neurodocker generate \
	--base neurodebian:stretch-non-free \
	--pkg-manager apt \
	--install fsl dcm2niix fsleyes fslview \
	--add-to-entrypoint "source /etc/fsl/fsl.sh" \
	--user=neuro \
	--workdir /home/neuro \
	--no-check-urls \
	> Dockerfile_fsl
