buildDate=`date +%Y%m%d`
echo $buildDate

sudo singularity build qsm_$buildDate Singularity.qsm
