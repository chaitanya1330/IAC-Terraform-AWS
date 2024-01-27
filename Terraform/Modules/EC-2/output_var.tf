output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.PublicInstance.id
}

output "private_instance_id" {
  description = "privateinstance ID of the EC2 instance"
  value       = aws_instance.PrivateInstance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.PublicInstance.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.PublicInstance.private_ip
}