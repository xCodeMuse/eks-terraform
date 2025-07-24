# Mock resources for testing

# Mock VPC
resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "test-vpc"
  }
}

# Mock Subnets
resource "aws_subnet" "test1" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  
  tags = {
    Name = "test-subnet-1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "test2" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  
  tags = {
    Name = "test-subnet-2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Mock EKS Cluster
resource "aws_eks_cluster" "test" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  
  vpc_config {
    subnet_ids = [aws_subnet.test1.id, aws_subnet.test2.id]
  }
}

# Mock IAM Role for EKS Cluster
resource "aws_iam_role" "cluster" {
  name = "test-eks-cluster-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Mock Security Group
resource "aws_security_group" "test" {
  name        = "test-sg"
  description = "Test security group"
  vpc_id      = aws_vpc.test.id
}

# Use the Fargate Profile module
module "fargate_profile" {
  source = "../.."
  
  cluster_name    = aws_eks_cluster.test.name
  
  subnet_ids = [aws_subnet.test1.id, aws_subnet.test2.id]
  
  # Fargate profile configuration
  name = var.name
  
  # Selectors for the Fargate profile
  selectors = var.selectors
  
  # IAM configuration
  create_iam_role            = var.create_iam_role
  cluster_ip_family          = var.cluster_ip_family
  iam_role_arn               = var.iam_role_arn
  iam_role_name              = var.iam_role_name
  iam_role_use_name_prefix   = var.iam_role_use_name_prefix
  iam_role_path              = var.iam_role_path
  iam_role_description       = var.iam_role_description
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_attach_cni_policy = var.iam_role_attach_cni_policy
  iam_role_additional_policies = var.iam_role_additional_policies
  iam_role_tags              = var.iam_role_tags
  
  # IAM role policy configuration
  create_iam_role_policy     = var.create_iam_role_policy
  iam_role_policy_statements = var.iam_role_policy_statements
  
  # Timeouts
  timeouts = var.timeouts
  
  tags = var.tags
}