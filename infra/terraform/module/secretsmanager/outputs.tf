output "cm_client_id" { value = aws_secretsmanager_secret.cm_client_id.arn }
output "cm_client_secret" { value = aws_secretsmanager_secret.cm_client_secret.arn }
output "directoryservice_root_password" { value = aws_secretsmanager_secret.directoryservice_root_password.arn }
output "directoryservice_root_username" { value = aws_secretsmanager_secret.directoryservice_root_username.arn }
output "vdc_client_id" { value = aws_secretsmanager_secret.vdc_client_id.arn }
output "vdc_client_secret" { value = aws_secretsmanager_secret.vdc_client_secret.arn }