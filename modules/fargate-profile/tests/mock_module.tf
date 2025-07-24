# Mock module for testing
# This file is used to mock the AWS resources for testing purposes

# Mock AWS provider is defined in provider.tf

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
  }
}

resource "aws_subnet" "test2" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  
  tags = {
    Name = "test-subnet-2"
  }
}

# Mock EKS Cluster
resource "aws_eks_cluster" "test" {
  name     = "test-eks-cluster"
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

# Mock data source for the EKS cluster
data "aws_eks_cluster" "test" {
  name = aws_eks_cluster.test.name
}

# Mock data source for the EKS cluster auth
data "aws_eks_cluster_auth" "test" {
  name = aws_eks_cluster.test.name
}