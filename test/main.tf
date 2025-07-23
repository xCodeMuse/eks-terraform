# Mock module for EKS cluster
# This module simulates the behavior of the real EKS module without creating actual AWS resources

provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
  
  # Mock endpoints
  endpoints {
    ec2            = "http://localhost:4566"
    eks            = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kms            = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
  
  # Mock account ID and partition
  access_key = "mock_access_key"
  secret_key = "mock_secret_key"
}

# Mock data for TLS certificate
provider "tls" {
  # No specific configuration needed for mocking
}

# Mock time provider
provider "time" {
  # No specific configuration needed for mocking
}

locals {
  mock_cluster_id                 = "mock-eks-${var.cluster_name}"
  mock_cluster_arn                = "arn:aws:eks:${var.region}:123456789012:cluster/${var.cluster_name}"
  mock_cluster_endpoint           = "https://${var.cluster_name}.eks.${var.region}.amazonaws.com"
  mock_cluster_auth_base64        = "bW9jay1jbHVzdGVyLWF1dGgtZGF0YQ==" # Base64 encoded "mock-cluster-auth-data"
  mock_cluster_security_group_id  = "sg-0123456789abcdef0"
  mock_node_security_group_id     = "sg-0123456789abcdef1"
  mock_oidc_provider_arn          = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
  mock_kms_key_arn                = var.create_kms_key ? "arn:aws:kms:${var.region}:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab" : null
  mock_cluster_primary_sg_id      = "sg-0123456789abcdef2"
  
  # Mock node group values
  mock_node_group_arn             = "arn:aws:eks:${var.region}:123456789012:nodegroup/${var.cluster_name}/default/1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p"
  mock_node_group_id              = "${var.cluster_name}:default"
  mock_node_group_status          = "ACTIVE"
  mock_node_group_asg_name        = "eks-${var.cluster_name}-default-1a2b3c4d-5e6f"
  
  # Determine if node groups are enabled
  has_node_groups = length(try(var.eks_managed_node_groups, {})) > 0
}

# Mock resource to simulate the EKS cluster
resource "null_resource" "mock_eks_cluster" {
  triggers = {
    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    vpc_id = var.vpc_id
    subnet_ids = join(",", var.subnet_ids)
    cluster_endpoint_private_access = var.cluster_endpoint_private_access
    cluster_endpoint_public_access = var.cluster_endpoint_public_access
    enable_irsa = var.enable_irsa
    create_kms_key = var.create_kms_key
  }
}

# Mock resource to simulate node groups if they are defined
resource "null_resource" "mock_eks_node_groups" {
  count = local.has_node_groups ? 1 : 0
  
  triggers = {
    cluster_name = var.cluster_name
    node_groups = jsonencode(var.eks_managed_node_groups)
  }
  
  depends_on = [null_resource.mock_eks_cluster]
}

# Outputs that match the real module
output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = local.mock_cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = local.mock_cluster_auth_base64
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = local.mock_cluster_endpoint
}

output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = local.mock_cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.cluster_name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = "https://oidc.eks.${var.region}.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = var.cluster_version
}

output "cluster_status" {
  description = "Status of the EKS cluster"
  value       = "ACTIVE"
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = local.mock_cluster_primary_sg_id
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group"
  value       = local.mock_cluster_security_group_id
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = local.mock_node_security_group_id
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider"
  value       = "oidc.eks.${var.region}.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = var.enable_irsa ? local.mock_oidc_provider_arn : null
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = local.mock_kms_key_arn
}

output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = local.has_node_groups ? {
    for key, value in var.eks_managed_node_groups : key => {
      node_group_arn  = local.mock_node_group_arn
      node_group_id   = local.mock_node_group_id
      node_group_resources = [{
        autoscaling_groups = [{
          name = local.mock_node_group_asg_name
        }]
      }]
      node_group_status = local.mock_node_group_status
      node_group_labels = try(value.labels, {})
      node_group_taints = try(value.taints, [])
    }
  } : {}
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = local.has_node_groups ? [local.mock_node_group_asg_name] : []
}

output "self_managed_node_groups" {
  description = "Map of attribute maps for all self managed node groups created"
  value       = {}
}

output "fargate_profiles" {
  description = "Map of attribute maps for all EKS Fargate Profiles created"
  value       = {}
}