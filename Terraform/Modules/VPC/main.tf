terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.26.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}


#creation of vpc

resource "aws_vpc" "myVPC" {
  cidr_block       = var.vpcCIDR
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "Terraform-VPC"
  }
}

#creation of internet gateway

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "Terraform-InternetGateway"
  }
}

#creation of nat gateway

resource "aws_eip" "ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NATGateway" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.PublicSubnet1.id

  tags = {
    Name = "Terraform-NAT"
  }
}


#creation of subnets

resource "aws_subnet" "PublicSubnet1" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PublicSubnet1CIDR
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Terraform-PublicSubnet-1"
  }
}

resource "aws_subnet" "PublicSubnet2" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PublicSubnet2CIDR
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Terraform-PublicSubnet-2"
  }
}

resource "aws_subnet" "PrivateSubnet1" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PrivateSubnet1CIDR
  availability_zone = "us-west-2b"
  tags = {
    Name = "Terraform-PrivateSubnet-1"
  }
}

resource "aws_subnet" "PrivateSubnet2" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PrivateSubnet2CIDR
  availability_zone = "us-west-2b"
  tags = {
    Name = "Terraform-PrivateSubnet-2"
  }
}

#creation of PublicRouteTable

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.myVPC.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGateway.id
  }
  tags = {
    Name = "Terraform-Public-RouteTable"
  }
}

#creation of Private RouteTable

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.myVPC.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGateway.id
  }
  tags = {
    Name = "Terraform-Private-RouteTable"
  }
}



resource "aws_route_table_association" "PublicSubnet1-Route-Association" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PublicSubnet2-Route-Association" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PrivateSubnet1-Route-Association" {
  subnet_id      = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_route_table_association" "PrivateSubnet2-Route-Association" {
  subnet_id      = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}


resource "aws_security_group" "SecurityGroup" {
  name        = "Terraform-SecurityGroup"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-SecurityGroup"
  }
}

# resource "aws_instance" "PublicInstance" {
#   ami           = "ami-036cd2042682e550f"
#   instance_type = var.InstanceTypeParameter
#   key_name = "cloud-formation-key"
#   security_groups = [aws_security_group.SecurityGroup.id]
#   subnet_id = aws_subnet.PublicSubnet1.id
#   tags = {
#     Name = "Terraform-PublicInstance"
#   }
# }

# resource "aws_instance" "PrivateInstance" {
#   ami           = "ami-036cd2042682e550f"
#   instance_type = var.InstanceTypeParameter
#   key_name = "cloud-formation"
#   security_groups = [aws_security_group.SecurityGroup.id]
#   subnet_id = aws_subnet.PrivateSubnet1.id
#   tags = {
#     Name = "Terraform-PrivateInstance"
#   }
# }