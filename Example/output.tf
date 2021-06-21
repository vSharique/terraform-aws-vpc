## output
output "vpc_id" {
  description = "AWS VPC ID"
  value       = module.vpc.vpc_id
}

output "ec2_sg_id" {
  description = "Security Group ID for EC2"
  value       = aws_security_group.sg.id
}

output "ec2_private_ip" {
  description = "EC2 private Ip"
  value       = aws_instance.my_ec2.private_ip
}

output "public_subnet_ids" {
  description = "VPC Public Subnet IDs"
  value       = module.vpc.*.public_subnet_ids
}

output "private_subnet_ids" {
  description = "VPC Private Subnet IDs"
  value       = module.vpc.*.private_subnet_ids
}

output "nat_gateway_eip" {
  description = "NAT Gateway EIP"
  value       = module.vpc.nat_gateway_eip
}

output "internet_gateway_id" {
  description = "Internet Gateway Id"
  value       = module.vpc.internet_gateway_id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = module.vpc.private_route_table_id
}