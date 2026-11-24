variable "name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_https" {
  description = "true if the ALB has an HTTPS listener (CloudFront then talks HTTPS to it)"
  type        = bool
  default     = false
}

variable "price_class" {
  description = "PriceClass_100 = US/EU edges only (cheapest)"
  type        = string
  default     = "PriceClass_100"
}
