## variables
variable "app_name" {
  type        = string
  description = "(Required) Application Name."
  default     = "myapp"
}

variable "availability_zones" {
  type        = list(string)
  description = "(Required) The AZ for the subnet."
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "delete_on_termination" {
  type        = bool
  description = "Delete volume on EC2 terminate."
  default     = true
}

variable "ec2_volume_size" {
  type        = string
  description = "EC2 volume size."
  default     = "100"

}
variable "instance_type" {
  type        = string
  description = "Specify EC2 Instance Type."
  default     = "t3a.micro"
}

variable "ec2_az" {
  type        = string
  description = "AZ in which EC2 will be launched."
  default     = "us-west-2a"
}

variable "public_subnets" {
  type        = list(string)
  description = "(Required) The CIDR block for the public subnet."
  default     = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "(Required) The CIDR block for the private subnet."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_cidr" {
  type        = string
  description = "(Required) The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to the resource."
  default = {
    "Environment" = "dev"
    "ManagedBy"   = "Terraform"
  }
}