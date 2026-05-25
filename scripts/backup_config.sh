#!/bin/bash

vars_file="$(pwd)/terraform.tfvars"

if [[ ! -f "$vars_file" ]]; then
    echo "Error: No se encontró el archivo terraform.tfvars en el directorio actual" >&2
    exit 1
fi

aws s3 cp "$vars_file" "s3://$S3_TERRAFORM_BACKEND_BUCKET"

