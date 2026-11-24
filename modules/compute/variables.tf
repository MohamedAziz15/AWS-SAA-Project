variable "name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_port" {
  type    = number
  default = 80
}

variable "app_sg_id" {
  type = string
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the RDS master credentials"
  type        = string
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "cpu_target" {
  description = "Target average CPU % for target tracking"
  type        = number
  default     = 50
}

variable "requests_per_target" {
  description = "Target ALB requests per instance per minute"
  type        = number
  default     = 1000
}

variable "sns_topic_arn" {
  description = "Optional SNS topic notified when the step-scaling alarm fires"
  type        = string
  default     = ""
}
