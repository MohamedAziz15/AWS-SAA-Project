# Route 53: alias record to the ALB + an HTTP health check on /health.
# Requires an existing public hosted zone (e.g. a cheap domain you own).
data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_health_check" "alb" {
  fqdn              = var.alb_dns_name
  type              = var.alb_https ? "HTTPS" : "HTTP"
  port              = var.alb_https ? 443 : 80
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = { Name = "${var.name}-alb-health" }
}

resource "aws_route53_record" "app" {
  zone_id         = data.aws_route53_zone.this.zone_id
  name            = "${var.record_name}.${var.domain_name}"
  type            = "A"
  set_identifier  = "primary"
  health_check_id = aws_route53_health_check.alb.id

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
