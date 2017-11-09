gcloud container builds submit --tag gcr.io/dicom2cloud/tgv-qsm:v20171109 . --timeout=2h15m5s

#Build in shell:
#export PROJECT_ID="$(gcloud config get-value project -q)"
#docker build -t gcr.io/${PROJECT_ID}/singularity-tgv-qsm:v1 .
#
#docker images
