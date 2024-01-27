# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.PublicInstance.id
# }

# output "private_instance_id" {
#   description = "privateinstance ID of the EC2 instance"
#   value       = aws_instance.PrivateInstance.id
# }

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.PublicInstance.public_ip
# }

# output "instance_private_ip" {
#   description = "Private IP address of the EC2 instance"
#   value       = aws_instance.PublicInstance.private_ip
# }

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.myVPC.id
}

output "public_subnet_1_id" {
  description = "Public ID  of the vpc"
  value       = aws_subnet.PublicSubnet1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID  of the vpc"
  value       = aws_subnet.PublicSubnet2.id
}

output "private_subnet_1_id" {
  description = "Private Subnet 1 ID  of the vpc"
  value       = aws_subnet.PrivateSubnet1.id
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID  of the vpc"
  value       = aws_subnet.PrivateSubnet2.id
}

output "IGW_id" {
  description = "id of IGW"
  value       = aws_internet_gateway.InternetGateway.id
}

output "NGW_id" {
  description = "id of NGW"
  value       = aws_nat_gateway.NATGateway.id
}


output "public_routetable_id" {
  description = "id of public route Table"
  value       = aws_route_table.PublicRouteTable.id
}

output "private_routetable_id" {
  description = "id of private route Table"
  value       =  aws_route_table.PrivateRouteTable.id
}
