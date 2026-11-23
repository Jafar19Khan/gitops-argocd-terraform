terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Dedicated VPC + Public Subnet + IGW (Eliminates all default VPC/subnet routing bugs)
resource "aws_vpc" "gitops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "gitops-argocd-vpc" }
}

resource "aws_internet_gateway" "gitops_igw" {
  vpc_id = aws_vpc.gitops_vpc.id
  tags   = { Name = "gitops-argocd-igw" }
}

resource "aws_subnet" "gitops_public_subnet" {
  vpc_id                  = aws_vpc.gitops_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags                    = { Name = "gitops-public-subnet" }
}

resource "aws_route_table" "gitops_public_rt" {
  vpc_id = aws_vpc.gitops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gitops_igw.id
  }
  tags = { Name = "gitops-public-rt" }
}

resource "aws_route_table_association" "gitops_rta" {
  subnet_id      = aws_subnet.gitops_public_subnet.id
  route_table_id = aws_route_table.gitops_public_rt.id
}

resource "aws_security_group" "gitops_sg" {
  name        = "gitops-argocd-sg"
  description = "Allow SSH, ArgoCD UI, and Sample App"
  vpc_id      = aws_vpc.gitops_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30443
    to_port     = 30443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k3s_argocd_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name != "" ? var.key_name : null
  subnet_id                   = aws_subnet.gitops_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.gitops_sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size           = 15
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = { Name = "gitops-argocd-server" }
}
