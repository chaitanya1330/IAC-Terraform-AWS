resource "aws_eks_node_group" "myWorkerNodeGroup" {
  cluster_name    = aws_eks_cluster.primary.name
  version         = var.k8s_version
  release_version = var.release_version
  node_group_name = "myWorkerNodeGroup"
  node_role_arn   = aws_iam_role.k8s-worker-node-role.arn
  subnet_ids      = aws_subnet.worker[*].id
  instance_types  = [var.machine_type]
  scaling_config {
    desired_size = var.min_node_count
    max_size     = var.max_node_count
    min_size     = var.min_node_count
  }
  timeouts {
    create = "15m"
    update = "1h"
  } 
  depends_on = [
    aws_iam_role_policy_attachment.k8s-worker-node-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8s-worker-node-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8s-worker-node-role-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_iam_role" "k8s-worker-node-role" {
  name = "eks-node-group-IAM-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "k8s-worker-node-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8s-worker-node-role.name
}

resource "aws_iam_role_policy_attachment" "k8s-worker-node-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8s-worker-node-role.name
}

resource "aws_iam_role_policy_attachment" "k8s-worker-node-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8s-worker-node-role.name
}


resource "aws_internet_gateway" "k8s-IGW" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "k8s-IGW"
  }
}

resource "aws_route_table" "k8s-Routetable" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s-IGW.id
  }
}

resource "aws_route_table_association" "worker" {
  count = 3
  subnet_id      = aws_subnet.worker[count.index].id
  route_table_id = aws_route_table.k8s-Routetable.id
}



