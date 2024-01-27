
#creation of ec2

# resource "aws_instance" "PublicInstance" {
#   ami           = "ami-036cd2042682e550f"
#   instance_type = var.InstanceTypeParameter
#   # key_name = data.aws_key_pair.key.id
#   tags = {
#     Name = "Terraform-PublicInstance"
#   }
# }


# data "aws_instance" "myawsinstance" {
#     instance_id = "i-05f8530ba5e906644"

#   filter {
#     name   = "image-id"
#     values = ["ami-036cd2042682e550f"]
#   }

#   filter {
#     name   = "tag:Name"
#     values = ["Terraform-PublicInstance"]
#   }
# }

# resource "aws_instance" "PrivateInstance" {
#   ami           = "ami-036cd2042682e550f"
#   instance_type = var.InstanceTypeParameter
  # key_name = "data"
  # subnet_id = "subnet-09610f4e936a0a17a"
#   tags = {
#     Name = "Terraform-PrivateInstance"
#   }
# }

resource "aws_instance" "testing-Instance" {
  ami           = "ami-036cd2042682e550f"
  instance_type = var.InstanceTypeParameter
  # key_name = "data"
  subnet_id = data.aws_subnet.selected.id
  tags = {
    Name = "Testing-Instance"
  }
}

# data "aws_subnet" "selected" {
#   id = "subnet-031eb50d99016e455"
# }

resource "aws_instance" "tested-Instance" {
  ami           = "ami-036cd2042682e550f"
  instance_type = var.InstanceTypeParameter
  # key_name = "data"
  tags = {
    Name = "Tested-Instance"
  }
}

data "aws_subnet" "selected" {
  id = "subnet-031eb50d99016e455"
}

resource "aws_security_group" "subnet" {
  vpc_id = data.aws_subnet.selected.vpc_id

  ingress {
    cidr_blocks = [data.aws_subnet.selected.cidr_block]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
}