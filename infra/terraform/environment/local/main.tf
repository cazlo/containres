provider "aws" {
  region                      = "us-west-1"  # LocalStack typically defaults to us-east-1
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
#   s3_force_path_style         = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    apigateway     = "http://localstack:4566"
    apigatewayv2   = "http://localstack:4566"
    cloudformation = "http://localstack:4566"
    cloudwatch     = "http://localstack:4566"
    dynamodb       = "http://localstack:4566"
    ec2            = "http://localstack:4566"
    es             = "http://localstack:4566"
    elasticache    = "http://localstack:4566"
    firehose       = "http://localstack:4566"
    iam            = "http://localstack:4566"
    kinesis        = "http://localstack:4566"
    lambda         = "http://localstack:4566"
    rds            = "http://localstack:4566"
    redshift       = "http://localstack:4566"
    route53        = "http://localstack:4566"
    s3             = "http://s3.localstack.localstack.cloud:4566"
    secretsmanager = "http://localstack:4566"
    ses            = "http://localstack:4566"
    sns            = "http://localstack:4566"
    sqs            = "http://localstack:4566"
    ssm            = "http://localstack:4566"
    stepfunctions  = "http://localstack:4566"
    sts            = "http://localstack:4566"
  }
}

module "config_table" {
  source = "../../module/dynamodb"
}

module "secretsmanager" {
  source = "../../module/secretsmanager"
}

module "sqs" {
  source = "../../module/sqs"
}