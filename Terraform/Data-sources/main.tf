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

resource "aws_instance" "PublicInstance" {
  ami           = "ami-0efcece6bed30fd98"
  instance_type = "t2.micro"
  key_name = "data"
  tags = {
    Name = "Terraform-PublicInstance"
  }
}

data "aws_instance" "myawsinstance" {
    filter {
      name = "tag:Name"
      values = ["Terraform-PublicInstance"]
    }

    depends_on = [
      aws_instance.PublicInstance
    ]
}

output "fetched_info_from_aws" {
  value = data.aws_instance.myawsinstance.public_ip
}