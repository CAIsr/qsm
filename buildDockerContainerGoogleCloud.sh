export PROJECT_ID="$(gcloud config get-value project -q)"

docker build -t gcr.io/${PROJECT_ID}/singularity-tgv-qsm:v1 .

docker images
