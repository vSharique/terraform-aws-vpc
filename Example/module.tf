## create vpc , subnet , igw, nat eip, nat, route table.
module "vpc" {
  source             = "../vpc_module"
  app_name           = var.app_name
  cidr               = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets

  tags = var.tags
}

## EC2 Security Group
resource "aws_security_group" "sg" {
  name        = "${var.app_name}-ec2-sg"
  description = "Allow inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

## EC2 key Pair
resource "tls_private_key" "ec2_pem" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mykey" {
  key_name   = "${var.app_name}-ec2-key"
  public_key = tls_private_key.ec2_pem.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ec2_pem.private_key_pem}' > ./${var.app_name}-ec2.pem"
  }
}

## EC2 Launch
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "my_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = "${var.app_name}-ec2-key"
  subnet_id              = module.vpc.private_subnet_ids[index(var.availability_zones, var.ec2_az)]
  vpc_security_group_ids = [aws_security_group.sg.id]

  ebs_optimized = true
  root_block_device {
    delete_on_termination = var.delete_on_termination
    encrypted             = true
    volume_size           = var.ec2_volume_size
  }

  volume_tags = merge(
    { Name = "${var.app_name}-volume" },
    var.tags
  )

  tags = merge(
    { Name = "${var.app_name}-ec2-private" },
    var.tags
  )

  depends_on = [
    module.vpc,
    tls_private_key.ec2_pem,
    aws_security_group.sg
  ]
}