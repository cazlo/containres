#!/bin/bash

mkdir /home/appuser/config
poetry run res-admin config generate --config-dir /home/appuser/config --values-file /opt/idea/app/containres/ideaadministrator/resources/config/values.yml
poetry run res-admin config update --cluster-name res-dev --aws-region us-west-1 --config-dir /home/appuser/config --force --overwrite

# get ARN to secret from tf output json
cm_client_id=$(cat /workspace/environment/local/tfstate.json | jq -r '.cm_client_id.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=cluster-manager.client_id,Type=string,Value=${cm_client_id}" --force
cm_client_secret=$(cat /workspace/environment/local/tfstate.json | jq -r '.cm_client_secret.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=cluster-manager.client_secret,Type=string,Value=${cm_client_secret}" --force

vdc_client_id=$(cat /workspace/environment/local/tfstate.json | jq -r '.vdc_client_id.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=vdc.client_id,Type=string,Value=${vdc_client_id}" --force
vdc_client_secret=$(cat /workspace/environment/local/tfstate.json | jq -r '.vdc_client_secret.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=vdc.client_secret,Type=string,Value=${vdc_client_secret}" --force
#poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=virtual-desktop-controller.client_secret,Type=string,Value=${vdc_client_secret}" --force

# todo should be cognito user pool id from tf output json
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=identity-provider.cognito.user_pool_id,Type=string,Value=$(uuid)" --force


# todo from TF output json
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=directoryservice.directory_id,Type=string,Value=$(uuid)" --force

# todo from tf output json
directoryservice_root_password=$(cat /workspace/environment/local/tfstate.json | jq -r '.directoryservice_root_password.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=directoryservice.root_password_secret_arn,Type=string,Value=${directoryservice_root_password}" --force

directoryservice_root_username=$(cat /workspace/environment/local/tfstate.json | jq -r '.directoryservice_root_username.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=directoryservice.root_username_secret_arn,Type=string,Value=${directoryservice_root_username}" --force


poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=cluster.load_balancers.internal_alb.load_balancer_dns_name,Type=string,Value=cluster-manager" --force
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=cluster.load_balancers.external_alb.load_balancer_dns_name,Type=string,Value=cluster-manager" --force


task_fifo_url=$(cat /workspace/environment/local/tfstate.json | jq -r '.task_fifo_url.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=directoryservice.ad_automation.sqs_queue_url,Type=string,Value=${task_fifo_url}" --force

poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=cluster-manager.notifications_queue_url,Type=string,Value=${task_fifo_url}" --force
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=cluster-manager.task_queue_url,Type=string,Value=${task_fifo_url}" --force

vdc_controller_url=$(cat /workspace/environment/local/tfstate.json | jq -r '.vdc_controller_url.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=vdc.controller_sqs_queue_url,Type=string,Value=${vdc_controller_url}" --force
vdc_events_url=$(cat /workspace/environment/local/tfstate.json | jq -r '.vdc_events_url.value')
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=vdc.events_sqs_queue_url,Type=string,Value=${vdc_events_url}" --force

# todo is this the IRSA role name for the vdc service account?
poetry run res-admin config set --cluster-name res-dev --aws-region us-west-1 "Key=vdc.controller_iam_role_id,Type=string,Value=000000000000" --force




openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /internal/res-dev/certs/idea.key -out /internal/res-dev/certs/idea.crt -subj '/CN=localhost'