variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID for public route table"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones"
}

variable "private_cidr_blocks" {
  type        = list(string)
  description = "List of Private CIDR blocks"
}

variable "public_cidr_blocks" {
  type        = list(string)
  description = "List of Public CIDR blocks"
}

variable "nat_gateway_enabled" {
  type        = bool
  description = "NAT Gateways enable parameter"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource"
  default     = {}
}
