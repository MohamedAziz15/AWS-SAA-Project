variable "name" {
  type = string
}

variable "domain_name" {
  description = "Existing Route 53 public hosted zone, e.g. example.com"
  type        = string
}

variable "record_name" {
  description = "Sub-domain to create, e.g. app -> app.example.com"
  type        = string
  default     = "app"
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "alb_https" {
  type    = bool
  default = false
}
