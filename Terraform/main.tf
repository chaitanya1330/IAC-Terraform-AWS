provider "aws" {
   region     = "ap-south-1"
}


module "VPC-Creation" {
  source = ".//modules/VPC"
}

module "EC2-Creation" {
  source = ".//modules/EC-2"
}
