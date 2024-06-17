terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_secretsmanager_secret" "cm_client_id" {
  name = "cluster-manager.client_id"
}

resource "aws_secretsmanager_secret_version" "cm_client_id" {
  secret_id = aws_secretsmanager_secret.cm_client_id.id
  secret_string = "foo"
}

resource "aws_secretsmanager_secret" "cm_client_secret" {
  name = "cluster-manager.client_secret"
}

resource "aws_secretsmanager_secret_version" "cm_client_secret" {
  secret_id = aws_secretsmanager_secret.cm_client_secret.id
  secret_string = "bar"
}

#####

resource "aws_secretsmanager_secret" "vdc_client_id" {
  name = "virtual-desktop-controller.client_id"
}

resource "aws_secretsmanager_secret_version" "vdc_client_id" {
  secret_id = aws_secretsmanager_secret.vdc_client_id.id
  secret_string = "foo"
}

resource "aws_secretsmanager_secret" "vdc_client_secret" {
  name = "virtual-desktop-controller.client_secret"
}

resource "aws_secretsmanager_secret_version" "vdc_client_secret" {
  secret_id = aws_secretsmanager_secret.vdc_client_secret.id
  secret_string = "bar"
}

#####

resource "aws_secretsmanager_secret" "directoryservice_root_username" {
  name = "directoryservice.root_username_secret_arn"
}

resource "aws_secretsmanager_secret_version" "directoryservice_root_username" {
  secret_id = aws_secretsmanager_secret.directoryservice_root_username.id
  secret_string = "foo"
}

resource "aws_secretsmanager_secret" "directoryservice_root_password" {
  name = "directoryservice.root_password_secret_arn"
}

resource "aws_secretsmanager_secret_version" "directoryservice_root_password" {
  secret_id = aws_secretsmanager_secret.directoryservice_root_password.id
  secret_string = "bar"
}