# Test configuration for EKS Managed Node Group module

# Configure AWS provider with skip options to avoid real AWS calls
provider "aws" {
  region                      = "us-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock-access-key"
  secret_key                  = "mock-secret-key"
  
  # Skip all AWS API calls
  s3_use_path_style           = true
}

# Mock data for testing
locals {
  cluster_name    = "test-eks-cluster"
  cluster_version = "1.28"
  
  vpc_id     = "vpc-12345678"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]
  
  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}

# Mock resources
resource "aws_eks_cluster" "this" {
  # This resource won't actually be created due to mock provider
  name     = local.cluster_name
  role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"
  
  vpc_config {
    subnet_ids = local.subnet_ids
  }
  
  # Prevent API calls during plan
  lifecycle {
    ignore_changes = all
  }
}

# Use the EKS Managed Node Group module
module "eks_managed_node_group" {
  source = "./.."
  
  cluster_name    = aws_eks_cluster.this.name
  cluster_version = local.cluster_version
  
  # Use mock values
  cluster_endpoint     = "https://test-eks-cluster.eks.amazonaws.com"
  cluster_auth_base64  = "dGVzdC1jbHVzdGVyLWF1dGg="
  cluster_service_cidr = "172.20.0.0/16"
  
  subnet_ids = local.subnet_ids
  
  # Node group configuration
  name         = "test-node-group"
  min_size     = 1
  max_size     = 3
  desired_size = 2
  
  # Instance configuration
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.medium"]
  
  tags = local.tags
  
  # Note: Cannot use lifecycle blocks in modules
}

# Outputs for testing
output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = module.eks_managed_node_group.node_group_arn
}

output "node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
  value       = module.eks_managed_node_group.node_group_id
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = module.eks_managed_node_group.node_group_status
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.eks_managed_node_group.launch_template_id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.eks_managed_node_group.launch_template_arn
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.eks_managed_node_group.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.eks_managed_node_group.iam_role_arn
}