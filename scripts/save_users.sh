#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Error: Se requiere un argumento, se recibió $#" >&2
    exit 1
fi

vars_file="$1"

if [[ ! -f "$vars_file" ]]; then
    echo "Error: No se encontró el archivo: $vars_file" >&2
    exit 1
fi

if [[ "${vars_file: -7}" != ".tfvars" ]]; then
    echo "Error: El archivo tiene que ser *.tfvars: $vars_file" >&2
    exit 1
fi

aws s3 cp "$vars_file" s3://mlops-terraform-backend-bucket-12345/

