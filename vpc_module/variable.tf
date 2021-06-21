## variable
variable "app_name" {
  type        = string
  description = "(Required) Application Name."
}

variable "availability_zones" {
  type        = list(string)
  description = "(Required) The AZ for the subnet."
}

variable "cidr" {
  type        = string
  description = "(Required) The CIDR block for the VPC."
}

variable "instance_tenancy" {
  type        = string
  description = "(Optional) A tenancy option for instances launched into the VPC."
  default     = "default"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = true

}

variable "enable_dns_support" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

variable "public_subnets" {
  type        = list(string)
  description = "(Required) The CIDR block for the public subnet."
}

variable "private_subnets" {
  type        = list(string)
  description = "(Required) The CIDR block for the private subnet."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to the resource."
  default     = {}
}