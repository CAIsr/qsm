# QSM Pipeline

This docker and singularity image provides the tgv-qsm algorithm (http://www.neuroimaging.at/pages/qsm.php). 

If you use this image, this is the reference to cite describing the QSM algorithm:
Langkammer, C; Bredies, K; Poser, BA; Barth, M; Reishofer, G; Fan, AP; Bilgic, B; Fazekas, F; Mainero; C; Ropele, S
Fast Quantitative Susceptibility Mapping using 3D EPI and Total Generalized Variation.
Neuroimage. 2015 May 1;111:622-30. doi: 10.1016/j.neuroimage.2015.02.041. PubMed 

# Using the image in singularity
installing singularity will depend on your operating system, here an exampe for ubuntu xenial
```
sudo wget -O- http://neuro.debian.net/lists/xenial.us-ca.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
sudo apt-get update
sudo apt-get install -y singularity-container
```

then you can download and run the container:
``` 
git clone https://github.com/NeuroDesk/transparent-singularity tgvqsm_1.0.0_20200929
cd tgvqsm_1.0.0_20200929
./run_transparent_singularity.sh tgvqsm_1.0.0_20200929
```

this will download the image, unpack it and provide a wrapper script for starting tgv_qsm:

The wrapper script can be started using
```
./tgv_qsm

```

Or you can open a shell into the container:
```
 singularity shell tgvqsm_1.0.0_20200929.*
```

you can also bind a different directory to your image (e.g. bind /data from your host to /data in your singularity image)
```
singularity shell --bind /data:/data/ tgvqsm_1.0.0_20200929.*
```

Here is an example for a single echo QSM processing:
```
tgv_qsm \
  -p phase.nii \
  -m magnitude_bet2_mask.nii.gz \
  -f 2.89 \
  -t 0.02 \
  -s \
  -o qsm
```
The -s option will scale the phase correctly if the phase dicom values are between -2048 and 2048 (should be default on Siemens VD and VE platforms). On the VB platform the phase is between 0 and 4096, so omit the -s option and scale the phase between -pi and pi:

# Using the image in docker
```
docker pull vnmd/tgvqsm_1.0.0:20200929
sudo docker run -it -v $PWD:/data vnmd/tgvqsm_1.0.0:20200929

cd data
tgv_qsm -p phase.nii -m magnitude_bet2_mask.nii.gz -f 2.89 -t 0.02 -s -o qsm
```

# Progress: [ ] 0.0% Illegal instruction
If this error comes up it means that the image was built on a CPU incompatible to the one your are running it on now. I haven't found a good workaround yet, except building the image again on this CPU type. If anyone has an idea how to solve this please get in touch :)

# The pipeline runs, but the output just contains zeros
If this error comes up it means that the image was built on a CPU incompatible to the one your are running it on now. I haven't found a good workaround yet, except building the image again on this CPU type. If anyone has an idea how to solve this please get in touch :)

# Using tgv_qsm in Windows Subsystem for Linux (example: Debian based system)
WSL 1.0 doesn't support singularity or docker containers (but WSL 2.0 will). But it is possible to directly install TGV QSM in a miniconda environment:
```
sudo apt install wget unzip gcc
wget https://repo.anaconda.com/miniconda/Miniconda2-4.6.14-Linux-x86_64.sh
bash Miniconda2-4.6.14-Linux-x86_64.sh
(install, accept agreement with yes, after install source bash again:)
bash
conda install -c anaconda cython==0.25.2
conda install numpy
conda install pyparsing
(make sure pip is not your system pip, but the one in miniconda: which pip)
pip install scipy==0.17.1 nibabel==2.1.0
wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip
unzip TGVQSM-plus.zip
cd TGVQSM-master-011045626121baa8bfdd6633929974c732ae35e3
python setup.py install
cd test_data
tgv_qsm  -p epi3d_test_phase.nii.gz -m epi3d_test_mask.nii.gz -f 2.89 -t 0.027 -o epi3d_test_QSM
```

# Adding fsl to WSL Ubuntu 18.04
```
wget -O- http://neuro.debian.net/lists/bionic.us-ca.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
sudo apt-get update
sudo apt-get install fsl-5.0-core
```
add ". /etc/fsl/5.0/fsl.sh" to the end of your .profile file
