resource "aws_db_subnet_group" "mySubnetGroup1" {
  name       = "my-subnet-group-1"
  subnet_ids = [for subnet in aws_subnet.myPrivateSubnet : subnet.id]
  tags = {
    Name = "mySubnetGroup-1"
  }
}
#creating DB-instance
resource "aws_db_instance" "myDBInstance" {
  allocated_storage      = 20
  db_name                = "myDbInstance"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.mySubnetGroup1.name
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.databaseSecurityGroup.id]
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  tags = {
    Name = "my-db-instance"
  }
}





