variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "manara-p1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "single_nat_gateway" {
  description = "true = 1 NAT (cheaper demo), false = 1 NAT per AZ (production HA)"
  type        = bool
  default     = true
}

variable "alb_ingress_cidrs" {
  description = "Who can reach the ALB directly. [] = CloudFront only."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_certificate_arn" {
  description = "Optional ACM certificate for HTTPS on the ALB"
  type        = string
  default     = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "asg_min" {
  type    = number
  default = 2
}

variable "asg_max" {
  type    = number
  default = 4
}

variable "asg_desired" {
  type    = number
  default = 2
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_deletion_protection" {
  description = "Keep false for the demo so terraform destroy works"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Existing Route 53 hosted zone (e.g. example.com). Empty = skip Route 53."
  type        = string
  default     = ""
}

variable "record_name" {
  type    = string
  default = "app"
}

variable "alert_email" {
  description = "Email that receives CloudWatch alarm notifications via SNS"
  type        = string
  default     = ""
}
