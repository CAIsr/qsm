# Singularity-tgv-qsm

This singularity image bundles the tgv-qsm algorithm (http://www.neuroimaging.at/pages/qsm.php) with bet2 (https://github.com/liangfu/bet2) and dcm2niix (https://github.com/rordenlab/dcm2niix) and all necessary dependencies. With this it provides a complete QSM processing pipeline starting from converting dicom images to nii, creating the brain mask using bet2 and then running tgv on this data.

If you use this image, this is the reference describing the QSM algorithm:
Langkammer, C; Bredies, K; Poser, BA; Barth, M; Reishofer, G; Fan, AP; Bilgic, B; Fazekas, F; Mainero; C; Ropele, S
Fast Quantitative Susceptibility Mapping using 3D EPI and Total Generalized Variation.
Neuroimage. 2015 May 1;111:622-30. doi: 10.1016/j.neuroimage.2015.02.041. PubMed 

# Using the image
```
singularity shell shub://2712
```

this will download the image, unpack it and then start a shell in the image mounting the folder where you executed the command from:

```
Progress |===================================| 100.0%
Singularity: Invoking an interactive shell within container...

Singularity Singularity CAIsr-singularity-tgv-qsm-v1.0_20170902.img:/test/test-tgv>
```

you can also bind a different directory to your image (e.g. bind /data from your host to /data in your singularity image)
```
singularity shell --bind /data:/data/ CAIsr-singularity-tgv-qsm-v1.0_20170902.img
```

or you can just run a single application from the image:
```
singularity exec CAIsr-singularity-tgv-qsm-v1.0_20170902.img bet2

Part of FSL (build 504)
BET (Brain Extraction Tool) v2.1 - FMRIB Analysis Group, Oxford

Usage:
bet2 <input_fileroot> <output_fileroot> [options]

Optional arguments (You may optionally specify one or more of):
        -o,--outline    generate brain surface outline overlaid onto original image
        -m,--mask <m>   generate binary brain mask
        -s,--skull      generate approximate skull image
        -n,--nooutput   don't generate segmented brain image output
        -f <f>          fractional intensity threshold (0->1); default=0.5; smaller values give larger brain outline estimates
        -g <g>          vertical gradient in fractional intensity threshold (-1->1); default=0; positive values give larger brain outline at bottom, smaller at top
        -r,--radius <r> head radius (mm not voxels); initial surface sphere is set to half of this
        -w,--smooth <r> smoothness factor; default=1; values smaller than 1 produce more detailed brain surface, values larger than one produce smoother, less detailed surface
        -c <x y z>      centre-of-gravity (voxels not mm) of initial mesh surface.
        -t,--threshold  -apply thresholding to segmented brain image and mask
        -e,--mesh       generates brain surface as mesh in vtk format
        -v,--verbose    switch on diagnostic messages
        -h,--help       displays this help, then exits
```

Here is an example for a full pipeline:
```
singularity exec CAIsr-singularity-tgv-qsm-v1.0_20170902.img dcm2niix -o ./ -f magnitude GR_M_5_QSM_p2_1mmIso_TE20/

singularity exec CAIsr-singularity-tgv-qsm-v1.0_20170902.img dcm2niix -o ./ -f phase GR_P_6_QSM_p2_1mmIso_TE20/

singularity exec CAIsr-singularity-tgv-qsm-v1.0_20170902.img bet2 magnitude.nii magnitude_bet2

singularity exec CAIsr-singularity-tgv-qsm-v1.0_20170902.img tgv_qsm -p phase.nii -m magnitude_bet2_mask.nii.gz -f 2.89 -t 0.02 -s -o qsm
```
