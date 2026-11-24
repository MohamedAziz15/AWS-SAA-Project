variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 80
}

variable "alb_ingress_cidrs" {
  description = "CIDRs allowed to reach the ALB directly. Empty list = only CloudFront can reach it."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
