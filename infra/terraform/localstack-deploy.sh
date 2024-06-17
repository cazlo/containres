#!/bin/sh

set -ex

#until wget -q -O - http://localstack:4566/_localstack/health | grep '\"dynamodb\": \"running\"'; do
#        echo 'Waiting for LocalStack to be ready...';
#        sleep 5;
#done;
cd environment/local;
terraform init && terraform apply -auto-approve
terraform output -json > tfstate.json