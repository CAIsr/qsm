# Singularity-tgv-qsm

This singularity image bundles the tgv-qsm algorithm (http://www.neuroimaging.at/pages/qsm.php) with bet2 (https://github.com/liangfu/bet2) and all necessary dependencies.

# Using the image
```
singularity shell shub://2711

```

this will download the image and unpack it and then start a shell in the image mounting the folder where you executed the command and you can now run all minc applications:

```
Progress |===================================| 100.0%
Singularity: Invoking an interactive shell within container...

Singularity CAIsr-singularity-minc-1.9.15-20170529.img:~> mincmath


Usage: mincmath [options] [<in1.mnc> ...] <out.mnc>
       mincmath -help

```

you can also bind a different directory to your image (e.g. bind /data from your host to /data in your singularity image)
```
singularity shell --bind /data:/data/ CAIsr-singularity-minc-1.9.15-20170529.img
```

or you can just run a single application from the image:
```
singularity exec CAIsr-singularity-minc-1.9.15-20170529.img mincmath

Usage: mincmath [options] [<in1.mnc> ...] <out.mnc>
       mincmath -help
```

and even X11 applications work:
```
singularity exec CAIsr-singularity-minc-1.9.15-20170529.img register
```
