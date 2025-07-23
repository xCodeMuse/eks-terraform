provider "aws" {
  region = var.region
}

locals {
  cluster_name = var.cluster_name
}

# Mock EKS cluster for testing purposes
# In a real scenario, you would create an actual EKS cluster
resource "aws_eks_cluster" "test" {
  name     = local.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

# Create a VPC for testing
resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "test-vpc-${local.cluster_name}"
  }
}

# Create subnets for testing
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "test-subnet-1-${local.cluster_name}"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "test-subnet-2-${local.cluster_name}"
  }
}

# Create IAM role for EKS cluster
resource "aws_iam_role" "cluster" {
  name = "test-eks-cluster-role-${local.cluster_name}"

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

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Create OIDC provider for IRSA
data "tls_certificate" "eks" {
  url = aws_eks_cluster.test.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.test.identity[0].oidc[0].issuer
}

# Call the Karpenter module
module "karpenter" {
  source = "../../../modules/karpenter"

  cluster_name = aws_eks_cluster.test.name
  
  # Enable IRSA for testing
  enable_irsa                  = true
  irsa_oidc_provider_arn       = aws_iam_openid_connect_provider.eks.arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]
  
  # Enable spot termination handling
  enable_spot_termination = true
  
  # Create node IAM role
  create_node_iam_role = true
  
  # Add tags for testing
  tags = var.tags
}