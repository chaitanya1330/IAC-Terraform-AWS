#-----------------------------------Creting Load Balancers----------------------------------
#CONFIGURING NLB
#security groups for newtork load balancer
resource "aws_security_group" "nlb_sg" {
  name        = "nlbSg"
  description = "Security group for nlb"
  vpc_id      = aws_vpc.myVPC01.id
  ingress {
    from_port   = 8000
    to_port     = 8000
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

#Creating network load balancer
resource "aws_lb" "backend_nlb_1" {
  name               = "backendNlb1"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_sg.id]
  subnets            = [aws_subnet.myPrivateSubnet[0].id]
  tags = {
    Name = "backend-nlb-1"
  }
}
#creating target group for backend nlb
resource "aws_lb_target_group" "backend_nlb_target_group" {
  target_type = "instance"
  port        = 8000
  protocol    = "TCP"
  vpc_id      = aws_vpc.myVPC01.id
  health_check {
    enabled           = true
    healthy_threshold = 2
    protocol          = "TCP"
    port              = 8000
    interval          = 60
    timeout           = 60
  }
  tags = {
    Name = "backend_nlb_target_group"
  }
}
#create a listner for nlb
resource "aws_lb_listener" "backend_nlb_1_listner" {
  load_balancer_arn = aws_lb.backend_nlb_1.arn
  port              = 8000
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_nlb_target_group.arn
  }
}
#attach instance to the target group
# resource "aws_lb_target_group_attachment" "backend_nlb_tg_attachment" {
#   target_group_arn = aws_lb_target_group.backend_nlb_target_group.arn
#   port = 8000
#   target_id = aws_instance.backendInstance.id
# }


#-----------------------------------Creating Auto Scaler------------------------------
#creating launch template
resource "aws_launch_template" "new_Backend_LT" {
  name_prefix            = "new_Backend_LT"
  image_id               = aws_ami_copy.backend_ami.id
  instance_type          = "t2.micro"
  key_name               = "backendKey"
  vpc_security_group_ids = [aws_security_group.backendSecurityGroup.id]
  tags = {
    Name = "backend-launch-template"
  }
}
#creating ASG
resource "aws_autoscaling_group" "backendASG" {
  name                      = "backendASG"
  desired_capacity          = 1
  max_size                  = 4
  min_size                  = 1
  vpc_zone_identifier       = [aws_subnet.myPrivateSubnet[0].id]
  health_check_grace_period = 120
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.backend_nlb_target_group.arn]
  launch_template {
    id = aws_launch_template.new_Backend_LT.id
  }

}
