output "rds-endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.aime-rds-instance.endpoint
}
