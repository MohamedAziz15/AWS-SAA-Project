output "db_instance_id" {
  value = aws_db_instance.this.identifier
}

output "db_address" {
  value = aws_db_instance.this.address
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "db_secret_arn" {
  description = "Secrets Manager secret created and managed by RDS for the master user"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
