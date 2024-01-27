resource "aws_eks_cluster" "primary" {
  name            = var.cluster_name
  role_arn        = aws_iam_role.control_plane.arn
  version         = var.k8s_version

  vpc_config {
    security_group_ids = [aws_security_group.worker.id]
    subnet_ids         = aws_subnet.worker[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_iam_role_policy_attachment.service,
  ]
}

resource "aws_iam_role" "control_plane" {
  name = "eks-cluster-control-palne-role"
  assume_role_policy = jsonencode(
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
          }
        ]
      }
  )
}

resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.control_plane.name
}

resource "aws_iam_role_policy_attachment" "service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.control_plane.name
}

resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    "Name"                                      = "k8s-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_security_group" "worker" {
  name        = "k8s-securityGroup"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.myvpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "k8s-securityGroup"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "worker" {
  count                   = 3
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "192.168.${count.index}.0/24"
  vpc_id                  = aws_vpc.myvpc.id
  map_public_ip_on_launch = true
  tags = {
    "Name"                                      = "k8s-subnet"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

