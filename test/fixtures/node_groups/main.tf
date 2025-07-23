# Include the mock provider configuration
include {
  path = "../../mock_provider.tf"
}

locals {
  cluster_name = var.cluster_name
}

# Create a mock VPC for testing
resource "null_resource" "mock_vpc" {
  triggers = {
    vpc_id = "vpc-0123456789abcdef0"
    cidr_block = "10.0.0.0/16"
    name = "test-vpc-${local.cluster_name}"
  }
}

# Create mock subnets for testing
resource "null_resource" "mock_subnet_1" {
  triggers = {
    subnet_id = "subnet-0123456789abcdef1"
    vpc_id = null_resource.mock_vpc.triggers.vpc_id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}a"
    name = "test-subnet-1-${local.cluster_name}"
  }
}

resource "null_resource" "mock_subnet_2" {
  triggers = {
    subnet_id = "subnet-0123456789abcdef2"
    vpc_id = null_resource.mock_vpc.triggers.vpc_id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.region}b"
    name = "test-subnet-2-${local.cluster_name}"
  }
}

# Include the mock module
include {
  path = "../../mock_module.tf"
}

# Call the mock module with the same variables as we would use for the real module
module "eks" {
  # Source is not needed as we're including the mock module directly
  # source = "../../../"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = null_resource.mock_vpc.triggers.vpc_id
  subnet_ids = [
    null_resource.mock_subnet_1.triggers.subnet_id,
    null_resource.mock_subnet_2.triggers.subnet_id
  ]

  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  # Enable IRSA
  enable_irsa = var.enable_irsa

  # Enable KMS encryption
  create_kms_key = var.create_kms_key

  # Add managed node groups
  eks_managed_node_groups = {
    default = {
      name         = "default-node-group"
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      instance_types = var.node_group_instance_types
      capacity_type  = var.node_group_capacity_type

      # Use launch template
      create_launch_template = true
      launch_template_name   = "default-node-group-lt"

      # Add disk configuration
      block_device_mappings = {
        root = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 20
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      # Add labels
      labels = {
        Environment = "test"
        NodeGroup   = "default"
      }

      # Add tags
      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }
    }
  }

  # Add tags
  tags = var.tags
  
  # Region for mock resources
  region = var.region
}