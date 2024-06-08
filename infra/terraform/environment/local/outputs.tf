output "cm_client_id" { value = module.secretsmanager.cm_client_id }
output "cm_client_secret" { value = module.secretsmanager.cm_client_secret }
output "directoryservice_root_password" { value = module.secretsmanager.directoryservice_root_password }
output "directoryservice_root_username" { value = module.secretsmanager.directoryservice_root_username }
output "vdc_client_id" { value = module.secretsmanager.vdc_client_id }
output "vdc_client_secret" { value = module.secretsmanager.vdc_client_secret }

output "task_fifo_url" { value = module.sqs.task_fifo_url }
output "vdc_events_url" {  value = module.sqs.vdc_events_url }
output "vdc_controller_url" {  value = module.sqs.vdc_controller_url }