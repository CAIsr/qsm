BootStrap:docker
From:ubuntu:latest

%files

%labels
MAINTAINER Steffen.Bollmann@cai.uq.edu.au

%environment
export PATH=/bet2/bin:/dcm2niix/build/bin:${PATH}

%runscript
echo "This gets run when you run the image!"

%post
echo "This section happens once after bootstrap to build the image."

apt update

apt upgrade -y

apt install -y wget unzip python3 python-numpy python-nibabel python-setuptools cython git cmake

wget http://neuro.debian.net/lists/xenial.au.full 

mv xenial.au.full /etc/apt/sources.list.d/neurodebian.sources.list

apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9

apt update

apt install -y fsl-5.0-complete


cd /

git clone https://github.com/rordenlab/dcm2niix

cd dcm2niix
mkdir build && cd build
cmake ..
make


cd /

wget "http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip" 

unzip /TGVQSM-plus.zip

cd TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3

python setup.py install


