terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_dynamodb_table" "modules" {
  name           = "${var.cluster_name}.modules"
  billing_mode   = "PAY_PER_REQUEST"  # Change to "PROVISIONED" if you want to set read/write capacities

  hash_key = "module_id"
  attribute {
    name = "module_id"
    type = "S"
  }

  tags = {
    "res:EnvironmentName": var.cluster_name
  }
}

resource "aws_dynamodb_table" "cluster_settings" {
  name           = "${var.cluster_name}.cluster-settings"
  billing_mode   = "PAY_PER_REQUEST"  # Change to "PROVISIONED" if you want to set read/write capacities

  hash_key       = "key"
  attribute {
    name = "key"
    type = "S"
  }

  tags = {
    "res:EnvironmentName": var.cluster_name
  }

}

resource "aws_kinesis_stream" "cluster_settings" {
  name        = "${var.cluster_name}.cluster-settings-kinesis-stream"
#   shard_count = 1

#   retention_period = 24
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
  tags = {
    "res:EnvironmentName": var.cluster_name
  }
}

resource "aws_iam_role" "cluster_settings" {
  name = "dynamodb-kinesis-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "dynamodb.amazonaws.com"
      }
    }]
  })

  tags = {
    "res:EnvironmentName": var.cluster_name
  }
}

resource "aws_iam_role_policy" "cluster_settings" {
  name = "dynamodb-kinesis-policy"
  role = aws_iam_role.cluster_settings.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = aws_kinesis_stream.cluster_settings.arn
      }
    ]
  })
}

resource "aws_dynamodb_kinesis_streaming_destination" "example" {
  table_name = aws_dynamodb_table.cluster_settings.name
  stream_arn = aws_kinesis_stream.cluster_settings.arn
# todo h ow to config                         'ApproximateCreationDateTimePrecision': 'MILLISECOND'
  depends_on = [
    aws_iam_role_policy.cluster_settings
  ]
}