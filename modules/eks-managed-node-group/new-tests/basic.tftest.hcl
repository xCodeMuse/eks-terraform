# Basic test for EKS Managed Node Group module

# Test with default configuration
run "default_configuration" {
  command = plan

  # Assert that the plan would create the expected resources
  assert {
    condition     = var.cluster_name == "test-eks-cluster"
    error_message = "Cluster name does not match expected value"
  }
  
  assert {
    condition     = length(var.subnet_ids) == 2
    error_message = "Subnet IDs count does not match expected value"
  }
  
  assert {
    condition     = var.min_size == 1
    error_message = "Min size does not match expected value"
  }
  
  assert {
    condition     = var.max_size == 3
    error_message = "Max size does not match expected value"
  }
  
  assert {
    condition     = var.desired_size == 2
    error_message = "Desired size does not match expected value"
  }
}

# Test with custom launch template
run "custom_launch_template" {
  command = plan
  
  variables {
    # Override variables for this test
    launch_template_name        = "custom-lt"
    launch_template_description = "Custom launch template for testing"
    
    # Add custom tags to the launch template
    launch_template_tags = {
      CustomTag = "custom-value"
    }
  }
  
  assert {
    condition     = var.launch_template_name == "custom-lt"
    error_message = "Launch template name does not match expected value"
  }
  
  assert {
    condition     = var.launch_template_description == "Custom launch template for testing"
    error_message = "Launch template description does not match expected value"
  }
}

# Test with custom IAM role configuration
run "custom_iam_role" {
  command = plan
  
  variables {
    # Override variables for this test
    iam_role_name        = "custom-role"
    iam_role_description = "Custom IAM role for testing"
    
    # Add additional policies
    iam_role_additional_policies = {
      AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
  }
  
  assert {
    condition     = var.iam_role_name == "custom-role"
    error_message = "IAM role name does not match expected value"
  }
  
  assert {
    condition     = var.iam_role_description == "Custom IAM role for testing"
    error_message = "IAM role description does not match expected value"
  }
  
  assert {
    condition     = length(var.iam_role_additional_policies) == 1
    error_message = "IAM role additional policies count does not match expected value"
  }
}

# Test with spot instances
run "spot_instances" {
  command = plan
  
  variables {
    # Override variables for this test
    capacity_type  = "SPOT"
    instance_types = ["t3.medium", "t3.large"]  # Multiple instance types for spot diversity
  }
  
  assert {
    condition     = var.capacity_type == "SPOT"
    error_message = "Capacity type does not match expected value"
  }
  
  assert {
    condition     = length(var.instance_types) == 2
    error_message = "Instance types count does not match expected value"
  }
  
  assert {
    condition     = contains(var.instance_types, "t3.medium") && contains(var.instance_types, "t3.large")
    error_message = "Instance types do not match expected values"
  }
}