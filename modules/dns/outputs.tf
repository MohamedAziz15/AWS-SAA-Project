output "app_fqdn" {
  value = aws_route53_record.app.fqdn
}

output "health_check_id" {
  value = aws_route53_health_check.alb.id
}
