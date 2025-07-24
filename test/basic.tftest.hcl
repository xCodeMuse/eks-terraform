variables {
  region           = "us-west-2"
  ec2_ssh_key_name = ""
}

provider "aws" {
  region = var.region
}

run "prepare_vpc" {
  module {
    source = "./test"
  }
}

# Validate basic cluster creation and configuration
run "validate_cluster_creation" {
  variables {
    region           = run.prepare_vpc.region
    ec2_ssh_key_name = run.prepare_vpc.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  assert {
    condition     = module.eks.cluster_name != ""
    error_message = "Cluster name should not be empty"
  }

  assert {
    condition     = module.eks.cluster_arn != ""
    error_message = "Cluster ARN should not be empty"
  }

  assert {
    condition     = module.eks.cluster_endpoint != ""
    error_message = "Cluster endpoint should not be empty"
  }

  assert {
    condition     = module.eks.cluster_version == "1.29"
    error_message = "Cluster version should be 1.29"
  }

  assert {
    condition     = module.eks.cluster_status == "ACTIVE"
    error_message = "Cluster status should be ACTIVE"
  }

  assert {
    condition     = module.eks.cluster_certificate_authority_data != ""
    error_message = "Cluster certificate authority data should not be empty"
  }
}

# Validate node groups
run "validate_node_groups" {
  variables {
    region           = run.prepare_vpc.region
    ec2_ssh_key_name = run.prepare_vpc.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

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

  assert {
    condition     = length(module.eks.eks_managed_node_groups_autoscaling_group_names) > 0
    error_message = "Should have at least one autoscaling group"
  }
}

# Validate Fargate profiles
run "validate_fargate_profiles" {
  variables {
    region           = run.prepare_vpc.region
    ec2_ssh_key_name = run.prepare_vpc.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  assert {
    condition     = length(module.eks.fargate_profiles) == 1
    error_message = "Should have 1 Fargate profile"
  }

  assert {
    condition     = contains(keys(module.eks.fargate_profiles), "default")
    error_message = "Should have a default Fargate profile"
  }
}

# Validate OIDC provider for IRSA
run "validate_oidc_provider" {
  variables {
    region           = run.prepare_vpc.region
    ec2_ssh_key_name = run.prepare_vpc.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  assert {
    condition     = module.eks.oidc_provider != ""
    error_message = "OIDC provider should not be empty"
  }

  assert {
    condition     = module.eks.oidc_provider_arn != ""
    error_message = "OIDC provider ARN should not be empty"
  }
}

# Validate security groups
run "validate_security_groups" {
  variables {
    region           = run.prepare_vpc.region
    ec2_ssh_key_name = run.prepare_vpc.ec2_ssh_key_name
  }

  module {
    source = "./test"
  }

  assert {
    condition     = module.eks.cluster_security_group_id != ""
    error_message = "Cluster security group ID should not be empty"
  }

  assert {
    condition     = module.eks.node_security_group_id != ""
    error_message = "Node security group ID should not be empty"
  }

  assert {
    condition     = module.eks.cluster_primary_security_group_id != ""
    error_message = "Cluster primary security group ID should not be empty"
  }
}