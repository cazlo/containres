terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_sqs_queue" "task_fifo" {
  fifo_queue = true
  name = "res-dev.fifo"
}

resource "aws_sqs_queue" "vdc_events" {
  fifo_queue = true
  name = "virtual-desktop-controller-events.fifo"
  fifo_throughput_limit = "perMessageGroupId"
  deduplication_scope = "messageGroup"
  content_based_deduplication = true
}

resource "aws_sqs_queue" "vdc_controller" {
  name = "virtual-desktop-controller-controller"
}

resource "aws_sns_topic" "ssm_commands" {
  name = "virtual-desktop-controller-ssm-commands-sns-topic"
}

resource "aws_sns_topic_subscription" "ssm_controller_sqs" {
  endpoint  = aws_sqs_queue.vdc_controller.arn
  protocol  = "sqs"
  topic_arn = aws_sns_topic.ssm_commands.arn
}