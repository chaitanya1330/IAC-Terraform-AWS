# # variable region {
# #   type        = string
# #   default     = "ap-south-1"
# #   description = "Enter the region for the launch of vpc"
# # }


variable vpcCIDR{
  type        = string
  default     = "192.168.0.0/16"
  description = "Enter the VPC CIDR for the launch of vpc"
}

variable PublicSubnet1CIDR{
  type        = string
  default     = "192.168.1.0/24"
  description = "Enter the PublicSubnet-1 CIDR for the launch of Subnet"
}

variable PublicSubnet2CIDR{
  type        = string
  default     = "192.168.2.0/24"
  description = "Enter the PublicSubnet-2 CIDR for the launch of Subnet"
}

variable PrivateSubnet1CIDR{
  type        = string
  default     = "192.168.3.0/24"
  description = "Enter the PrivateSubnet-1 CIDR for the launch of Subnet"
}

variable PrivateSubnet2CIDR{
  type        = string
  default     = "192.168.4.0/24"
  description = "Enter the PrivateSubnet-2 CIDR for the launch of Subnet"
}

# variable InstanceTypeParameter{
#   type        = string
#   default     = "t2.micro"
#   description = "Enter the type of instance"
# }
