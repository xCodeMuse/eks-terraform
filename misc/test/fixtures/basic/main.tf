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

  # Add tags
  tags = var.tags
  
  # Region for mock resources
  region = var.region
}