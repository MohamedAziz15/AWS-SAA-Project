variable "name" {
  type = string
}

variable "alert_email" {
  description = "Email for alarm notifications. Empty = topic only, no subscription."
  type        = string
  default     = ""
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "db_instance_id" {
  type = string
}

variable "web_acl_name" {
  type = string
}
