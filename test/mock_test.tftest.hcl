variables {
  region           = "us-west-2"
  ec2_ssh_key_name = ""
}

provider "aws" {
  region = var.region
  
  # Skip credential validation for mock testing
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  # Use mock endpoints
  endpoints {
    ec2            = "http://localhost:4566"
    eks            = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kms            = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    autoscaling    = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

# Test basic module configuration
run "validate_module_configuration" {
  command = plan

  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  # Validate the plan contains the expected resources
  assert {
    condition     = length(data.aws_availability_zones.available) > 0
    error_message = "No availability zones found"
  }

  assert {
    condition     = length(module.vpc) > 0
    error_message = "VPC module not configured correctly"
  }

  assert {
    condition     = length(module.eks) > 0
    error_message = "EKS module not configured correctly"
  }
}

# Test cluster configuration
run "validate_cluster_configuration" {
  command = plan

  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  # Validate cluster configuration
  assert {
    condition     = module.eks.cluster_name != ""
    error_message = "Cluster name should not be empty"
  }

  assert {
    condition     = module.eks.cluster_version == "1.29"
    error_message = "Cluster version should be 1.29"
  }

  assert {
    condition     = module.eks.cluster_endpoint_private_access == true
    error_message = "Cluster endpoint private access should be enabled"
  }

  assert {
    condition     = module.eks.cluster_endpoint_public_access == true
    error_message = "Cluster endpoint public access should be enabled"
  }
}

# Test node group configuration
run "validate_node_group_configuration" {
  command = plan

  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  # Validate node group configuration
  assert {
    condition     = length(module.eks.eks_managed_node_groups) == 2
    error_message = "Should have 2 EKS managed node groups"
  }

  assert {
    condition     = contains(keys(module.eks.eks_managed_node_groups), "default_node_group")
    error_message = "Should have a default_node_group"
  }

  assert {
    condition     = contains(keys(module.eks.eks_managed_node_groups), "spot")
    error_message = "Should have a spot node group"
  }
}

# Test Fargate profile configuration
run "validate_fargate_profile_configuration" {
  command = plan

  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  # Validate Fargate profile configuration
  assert {
    condition     = length(module.eks.fargate_profiles) == 1
    error_message = "Should have 1 Fargate profile"
  }

  assert {
    condition     = contains(keys(module.eks.fargate_profiles), "default")
    error_message = "Should have a default Fargate profile"
  }
}

# Test add-on configuration
run "validate_addon_configuration" {
  command = plan

  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  # Validate add-on configuration
  assert {
    condition     = length(module.eks.cluster_addons) == 3
    error_message = "Should have 3 cluster add-ons"
  }

  assert {
    condition     = contains(keys(module.eks.cluster_addons), "coredns")
    error_message = "Should have coredns add-on"
  }

  assert {
    condition     = contains(keys(module.eks.cluster_addons), "kube-proxy")
    error_message = "Should have kube-proxy add-on"
  }

  assert {
    condition     = contains(keys(module.eks.cluster_addons), "vpc-cni")
    error_message = "Should have vpc-cni add-on"
  }
}

# Test security group configuration
run "validate_security_group_configuration" {
  command = plan

  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  # Validate security group configuration
  assert {
    condition     = module.eks.cluster_security_group_id != ""
    error_message = "Cluster security group ID should not be empty"
  }

  assert {
    condition     = module.eks.node_security_group_id != ""
    error_message = "Node security group ID should not be empty"
  }
}

# Test IAM role configuration
run "validate_iam_role_configuration" {
  command = plan

  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  # Validate IAM role configuration
  assert {
    condition     = module.eks.cluster_iam_role_name != ""
    error_message = "Cluster IAM role name should not be empty"
  }

  assert {
    condition     = module.eks.cluster_iam_role_arn != ""
    error_message = "Cluster IAM role ARN should not be empty"
  }
}