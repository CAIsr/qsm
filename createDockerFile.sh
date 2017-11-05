

docker run --rm kaczmarj/neurodocker:v0.3.1 generate -b debian:stretch -p apt --fsl version=5.0.10 > Dockerfile



#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user




#neurodocker generate --base debian:stretch --pkg-manager apt --fsl version=5.0.10 > Dockerfile
