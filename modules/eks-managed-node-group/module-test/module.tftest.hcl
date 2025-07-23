# Test file for EKS Managed Node Group module

# Test with default configuration
run "default_configuration" {
  command = plan
  
  # Assert that the module outputs match expected values
  assert {
    condition     = module.eks_managed_node_group.node_group_id != null
    error_message = "Node group ID should not be null"
  }
  
  assert {
    condition     = module.eks_managed_node_group.iam_role_name != null
    error_message = "IAM role name should not be null"
  }
  
  assert {
    condition     = module.eks_managed_node_group.launch_template_id != null
    error_message = "Launch template ID should not be null"
  }
}

# Test with custom capacity configuration
run "custom_capacity" {
  command = plan
  
  variables {
    # Override module variables
    capacity_type  = "SPOT"
    instance_types = ["t3.medium", "t3.large"]
    min_size       = 2
    max_size       = 5
    desired_size   = 3
  }
  
  # Assert that the module configuration is applied correctly
  assert {
    condition     = module.eks_managed_node_group.node_group_id != null
    error_message = "Node group ID should not be null"
  }
}

# Test with custom launch template
run "custom_launch_template" {
  command = plan
  
  variables {
    # Override module variables
    create_launch_template          = true
    launch_template_name            = "custom-lt"
    launch_template_use_name_prefix = true
    launch_template_description     = "Custom launch template for testing"
  }
  
  # Assert that the module configuration is applied correctly
  assert {
    condition     = module.eks_managed_node_group.launch_template_id != null
    error_message = "Launch template ID should not be null"
  }
}

# Test with custom IAM role
run "custom_iam_role" {
  command = plan
  
  variables {
    # Override module variables
    create_iam_role            = true
    iam_role_name              = "custom-role"
    iam_role_use_name_prefix   = true
    iam_role_description       = "Custom IAM role for testing"
    iam_role_additional_policies = {
      AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
  }
  
  # Assert that the module configuration is applied correctly
  assert {
    condition     = module.eks_managed_node_group.iam_role_name != null
    error_message = "IAM role name should not be null"
  }
  
  assert {
    condition     = module.eks_managed_node_group.iam_role_arn != null
    error_message = "IAM role ARN should not be null"
  }
}

# Test with Kubernetes labels and taints
run "labels_and_taints" {
  command = plan
  
  variables {
    # Add Kubernetes labels
    labels = {
      "environment" = "test"
      "app"         = "example"
      "team"        = "platform"
    }
    
    # Add Kubernetes taints
    taints = {
      dedicated = {
        key    = "dedicated"
        value  = "platform"
        effect = "NO_SCHEDULE"
      }
    }
  }
  
  # Assert that the module configuration is applied correctly
  assert {
    condition     = module.eks_managed_node_group.node_group_id != null
    error_message = "Node group ID should not be null"
  }
}

# Test with autoscaling schedules
run "autoscaling_schedules" {
  command = plan
  
  variables {
    # Enable autoscaling schedules
    create_schedule = true
    
    # Define schedules
    schedules = {
      scale-up = {
        min_size      = 3
        max_size      = 6
        desired_size  = 4
        recurrence    = "0 8 * * MON-FRI"  # 8 AM on weekdays
        time_zone     = "UTC"
      }
      scale-down = {
        min_size      = 1
        max_size      = 3
        desired_size  = 1
        recurrence    = "0 18 * * MON-FRI"  # 6 PM on weekdays
        time_zone     = "UTC"
      }
    }
  }
  
  # Assert that the module configuration is applied correctly
  assert {
    condition     = module.eks_managed_node_group.node_group_id != null
    error_message = "Node group ID should not be null"
  }
}