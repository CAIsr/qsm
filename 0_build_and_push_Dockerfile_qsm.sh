buildDate=`date +%Y%m%d`
echo $buildDate

sudo docker build -t qsm:$buildDate -f  Dockerfile_qsm .

docker tag qsm:$buildDate caid/qsm:$buildDate
docker push caid/qsm:$buildDate
docker tag qsm:$buildDate caid/qsm:latest
docker push caid/qsm:latest

