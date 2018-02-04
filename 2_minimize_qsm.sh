# Run the container.
#sudo docker run --rm -it --name qsm-reprozip-container --security-opt=seccomp:unconfined caisrgit/qsm:master

# (in a new terminal window)
cmd="antsMotionCorr -d 3 -a /home/func.nii.gz -o /home/func_avg.nii.gz"
#neurodocker reprozip-trace ants-reprozip-container "$cmd"

#reprounzip docker setup neurodocker-reprozip.rpz test
