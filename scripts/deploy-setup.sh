#!/bin/bash

apt update
apt install docker.io -y
snap install aws-cli --classic

mkdir -p ${releases_dir}
aws s3 sync s3://${s3_bucket}/ ${releases_dir}

aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${ecr_repository}
docker pull ${ecr_repository}:latest
docker run -d \
    -v ${releases_dir}:/app/models \
    ${ecr_repository}:latest python3 worker.py
docker run -d \
    -v ${releases_dir}:/app/models \
    -p 8000:8000 \
    ${ecr_repository}:latest fastapi run app.py
