output "cloudfront_url" {
  description = "Main entry point: CloudFront -> ALB (dynamic) + S3 (/static/*)"
  value       = "https://${module.edge.cloudfront_domain_name}"
}

output "alb_url" {
  value = "http://${module.alb.alb_dns_name}"
}

output "route53_url" {
  value = var.domain_name == "" ? null : "http://${module.dns[0].app_fqdn}"
}

output "asg_name" {
  value = module.compute.asg_name
}

output "db_endpoint" {
  value = module.database.db_address
}

output "db_secret_arn" {
  value = module.database.db_secret_arn
}

output "dashboard_url" {
  value = "https://console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${module.monitoring.dashboard_name}"
}

output "ssm_connect_hint" {
  value = "aws ssm start-session --target <instance-id>   (find IDs in the ASG: ${module.compute.asg_name})"
}
