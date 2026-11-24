variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "app_port" {
  type    = number
  default = 80
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS (same region as the ALB). Empty = HTTP only."
  type        = string
  default     = ""
}

variable "waf_rate_limit" {
  description = "Max requests per 5 minutes from one IP before WAF blocks it"
  type        = number
  default     = 1000
}

variable "deletion_protection" {
  type    = bool
  default = false
}
