BootStrap:docker
From:ubuntu:latest

%files

%labels
MAINTAINER Steffen.Bollmann@cai.uq.edu.au

%environment
export PATH=/bet2/bin:${PATH}

%runscript
echo "This gets run when you run the image!"

%post
echo "This section happens once after bootstrap to build the image."

apt update

apt upgrade -y

apt install -y wget unzip python3 python-numpy python-nibabel python-setuptools cython git cmake



cd /

git clone https://github.com/liangfu/bet2

cd bet2

mkdir build
cd build
cmake ..
make -j6


cd /

wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip /TGVQSM-plus.zip

unzip /TGVQSM-plus.zip

cd TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3

python setup.py install


%test
tgv_qsm
