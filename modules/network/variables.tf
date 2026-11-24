variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (a /16 is expected)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of Availability Zones to use"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 4
    error_message = "Use 2 to 4 AZs for high availability."
  }
}

variable "single_nat_gateway" {
  description = "true = one NAT Gateway shared by all AZs (cheaper), false = one per AZ (highly available)"
  type        = bool
  default     = true
}
