## output
output "vpc_id" {
  description = "AWS VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
    description = "VPC Subnet IDs"
    value = aws_subnet.public.*.id 
}

output "private_subnet_ids" {
    description = "VPC Subnet IDs"
    value = aws_subnet.private.*.id 
}

output "nat_gateway_eip" {
    description = "NAT Gateway EIP"
    value = aws_eip.nat_eip.public_ip
}

output "internet_gateway_id" {
    description = "Internet Gateway Id"
    value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
    description = "Public Route Table ID"
    value = aws_route_table.public.id
}

output "private_route_table_id" {
    description = "Private Route Table ID"
    value = aws_route_table.private.id
}