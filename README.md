# QSM Pipeline

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/557)

This docker and singularity image bundles the tgv-qsm algorithm (http://www.neuroimaging.at/pages/qsm.php) with fsl (https://www.fmrib.ox.ac.uk/fsl) and dcm2niix (https://github.com/rordenlab/dcm2niix) and all necessary dependencies. This image provides a complete QSM processing pipeline starting from converting dicom images to nii, creating the brain mask using bet, rescaling phase data, running tgv on this data and checking the outputs.

If you use this image, this is the reference describing the QSM algorithm:
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
singularity shell shub://CAIsr/qsm
```

this will download the image, unpack it and then start a shell in the image mounting the folder where you executed the command from:

```
Progress |===================================| 100.0%
Singularity: Invoking an interactive shell within container...

```

you can also bind a different directory to your image (e.g. bind /data from your host to /data in your singularity image)
```
singularity shell --bind /data:/data/ CAIsr-qsm-v1.2.3-latest.simg
```

or you can just run a single application from the image:
```
singularity exec CAIsr-qsm-v1.2.3-latest.simg bet2
```

Here is an example for a single echo QSM pipeline:
```
singularity exec CAIsr-qsm-v1.2.3-latest.simg dcm2niix -o ./ -f magnitude GR_M_5_QSM_p2_1mmIso_TE20/

singularity exec CAIsr-qsm-v1.2.3-latest.simg dcm2niix -o ./ -f phase GR_P_6_QSM_p2_1mmIso_TE20/

singularity exec CAIsr-qsm-v1.2.3-latest.simg bet2 magnitude.nii magnitude_bet2

singularity exec CAIsr-qsm-v1.2.3-latest.simg tgv_qsm \
  -p phase.nii \
  -m magnitude_bet2_mask.nii.gz \
  -f 2.89 \
  -t 0.02 \
  -s \
  -o qsm
```
The -s option will scale the phase correctly if the phase dicom values are between -2048 and 2048 (should be default on Siemens VD and VE platforms). On the VB platform the phase is between 0 and 4096, so omit the -s option and scale the phase between -pi and pi:

```
fslmaths phase.nii -div 4096 -mul 6.28318530718 -sub 3.14159265359 phase_scaled.nii
```

And an example for a multiecho QSM pipeline:
```
subject=yoursubjectID

echoTime=(`seq 0.0049 0.0049 0.0295`)

fslsplit ${subject}_gre6magni.nii ${subject}_gre6magni_split_
fslsplit ${subject}_gre6phase.nii ${subject}_gre6phase_split_

for echoNbr in {0..5}; do
 bet ${subject}_gre6magni_split_000${echoNbr}.nii ${subject}_gre6magni_split_000${echoNbr}_bet -R -f 0.6 -m
 fslcpgeom ${subject}_gre6magni_split_000${echoNbr}_bet_mask.nii ${subject}_gre6phase_split_000${echoNbr}.nii
done

for echoNbr in {0..5}; do
        singularity \
        exec \
        --bind $PWD:/data \
        CAIsr-qsm-v1.2.3-latest.simg \
        tgv_qsm \
        -p /data/${subject}_gre6phase_split_000${echoNbr}.nii \
        -m /data/${subject}_gre6magni_split_000${echoNbr}_bet_mask.nii \
        -f 2.89 \
        -e 0 \
        -t ${echoTime[5]} \
        -s \
        -o tgvqsm
done

```

After processing every echo, the data can be combined, by diving the sum of the QSMs by the sum of the masks - e.g.:
```
fslmaths /data/${subject}_gre6magni_split_000${echoNbr}_bet_mask.nii -add /data/${subject}_gre6magni_split_000${echoNbr}_bet_mask.nii .... mask_sum
fslmaths qsm_echo1 -add qsm_echo2 .... qsm_sum
fslmaths qsm_sum -div mask_sum final_qsm.nii
```

# Using the image in docker
```
sudo docker pull caid/qsm
sudo docker run -it -v $PWD:/data caid/qsm

cd data
dcm2niix -o ./ -f magnitude GR_M_5_QSM_p2_1mmIso_TE20/
dcm2niix -o ./ -f phase GR_P_6_QSM_p2_1mmIso_TE20/
bet2 magnitude.nii magnitude_bet2
tgv_qsm -p phase.nii -m magnitude_bet2_mask.nii.gz -f 2.89 -t 0.02 -s -o qsm
```

# Progress: [ ] 0.0% Illegal instruction
If this error comes up it means that the image was built on a CPU incompatible to the one your are running it on now. I haven't found a good workaround yet, except building the image again on this CPU type. If anyone has an idea how to solve this please get in touch :)

# Using tgv_qsm in Windows Subsystem for Linux (WSL 1.0)
WSL 1.0 doesn't support singularity or docker containers (but WSL 2.0 will). But it is possible to directly install TGV QSM in a miniconda environment:
```
wget https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh
bash Miniconda2-latest-Linux-x86_64.sh
conda install -c anaconda cython==0.25.2
conda install numpy
pip install scipy==0.17.1
wget http://www.neuroimaging.at/media/qsm/TGVQSM-plus.zip
sudo apt install unzip
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
