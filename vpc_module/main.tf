## VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { "Name" = "${var.app_name}-vpc" },
    var.tags
  )
}

## Public Subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    { "Name" = format("${var.app_name}-public-subnet-%s", element(var.availability_zones, count.index)) },
    var.tags
  )
}

## Private Subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    { "Name" = format("${var.app_name}-private-subnet-%s", element(var.availability_zones, count.index)) },
    var.tags
  )
}


## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { "Name" = "${var.app_name}-public-igw" },
    var.tags
  )
}

## EIP NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = merge(
    { "Name" = "${var.app_name}-nat-eip" },
    var.tags
  )
}

## NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.0.id

  tags = merge(
    { "Name" = "${var.app_name}-private-nat" },
    var.tags
  )
}

## Route Table Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    { "Name" = "${var.app_name}-public-rt" },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

## Route Table Private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    { "Name" = "${var.app_name}-private-rt" },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
