buildDate=`date +%Y%m%d`
echo $buildDate
imageName='fsl'

sudo docker build -t ${imageName}:$buildDate -f  Dockerfile_fsl .

docker tag ${imageName}:$buildDate caid/fsl:$buildDate
docker push caid/${imageName}:$buildDate
docker tag ${imageName}:$buildDate caid/fsl:latest
docker push caid/${imageName}:latest

