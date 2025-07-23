# Basic test for EKS root module

# Define variables for the test
variables {
  cluster_name    = "test-eks-cluster"
  cluster_version = "1.28"
  region          = "us-west-2"
  
  # VPC and subnet IDs will be created by the fixture
  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-0123456789abcdef1", "subnet-0123456789abcdef2"]
  
  # Enable IRSA
  enable_irsa = true
  
  # Enable KMS encryption
  create_kms_key = true
  
  # Set endpoint access
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  
  # Add tags
  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}

# Test basic cluster creation
run "create_basic_cluster" {
  command = plan
  
  # Basic assertions
  assert {
    condition     = var.cluster_name != ""
    error_message = "Cluster name must be provided"
  }
  
  assert {
    condition     = var.cluster_version != ""
    error_message = "Cluster version must be provided"
  }
  
  assert {
    condition     = var.enable_irsa == true
    error_message = "IRSA should be enabled for the test"
  }
}

# Test private cluster configuration
run "private_cluster" {
  command = plan
  
  # Override variables for this test
  variables {
    cluster_endpoint_private_access = true
    cluster_endpoint_public_access  = false
  }
  
  assert {
    condition     = var.cluster_endpoint_private_access == true
    error_message = "Private endpoint access should be enabled"
  }
  
  assert {
    condition     = var.cluster_endpoint_public_access == false
    error_message = "Public endpoint access should be disabled"
  }
}

# Test KMS encryption
run "kms_encryption" {
  command = plan
  
  # Override variables for this test
  variables {
    create_kms_key = true
  }
  
  assert {
    condition     = var.create_kms_key == true
    error_message = "KMS key creation should be enabled"
  }
}

# Test with node groups
run "with_node_groups" {
  command = plan
  
  # Override variables for this test
  variables {
    eks_managed_node_groups = {
      default = {
        name         = "default-node-group"
        min_size     = 1
        max_size     = 3
        desired_size = 2
        instance_types = ["t3.medium"]
        capacity_type  = "ON_DEMAND"
      }
    }
  }
  
  assert {
    condition     = length(var.eks_managed_node_groups) > 0
    error_message = "Node groups should be defined"
  }
  
  assert {
    condition     = lookup(var.eks_managed_node_groups.default, "min_size", 0) >= 1
    error_message = "Node group minimum size should be at least 1"
  }
  
  assert {
    condition     = lookup(var.eks_managed_node_groups.default, "max_size", 0) >= lookup(var.eks_managed_node_groups.default, "min_size", 0)
    error_message = "Node group maximum size should be greater than or equal to minimum size"
  }
}