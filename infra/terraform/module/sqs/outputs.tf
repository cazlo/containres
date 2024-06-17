output "task_fifo_url" {
  value = aws_sqs_queue.task_fifo.url
}

output "vdc_events_url" {
  value = aws_sqs_queue.vdc_events.url
}

output "vdc_controller_url" {
  value = aws_sqs_queue.vdc_controller.url
}