#!/bin/bash

# Update the system and install server components
apt update
apt install python3-pip python3-venv -y

# Prepare the python environment
python3 -m venv /opt/venv
source /opt/venv/bin/activate

# Setup mlflow
pip install mlflow psycopg2-binary
mlflow server \
    --backend-store-uri postgresql://${db_user}:${db_passwd}@${db_endpoint}/${db_name} \
    --default-artifact-root s3://${s3_bucket} \
    --host 0.0.0.0 \
    --port 5000 \
    --disable-security-middleware

