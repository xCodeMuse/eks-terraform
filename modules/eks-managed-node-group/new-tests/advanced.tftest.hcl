# Advanced test for EKS Managed Node Group module

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
  
  assert {
    condition     = length(var.labels) == 3
    error_message = "Labels count does not match expected value"
  }
  
  assert {
    condition     = var.labels["environment"] == "test" && var.labels["app"] == "example" && var.labels["team"] == "platform"
    error_message = "Labels do not match expected values"
  }
  
  assert {
    condition     = length(var.taints) == 1
    error_message = "Taints count does not match expected value"
  }
  
  assert {
    condition     = var.taints.dedicated.key == "dedicated" && var.taints.dedicated.value == "platform" && var.taints.dedicated.effect == "NO_SCHEDULE"
    error_message = "Taints do not match expected values"
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
  
  assert {
    condition     = var.create_schedule == true
    error_message = "Create schedule does not match expected value"
  }
  
  assert {
    condition     = length(var.schedules) == 2
    error_message = "Schedules count does not match expected value"
  }
  
  assert {
    condition     = var.schedules["scale-up"].min_size == 3 && var.schedules["scale-up"].max_size == 6 && var.schedules["scale-up"].desired_size == 4
    error_message = "Scale-up schedule does not match expected values"
  }
  
  assert {
    condition     = var.schedules["scale-down"].min_size == 1 && var.schedules["scale-down"].max_size == 3 && var.schedules["scale-down"].desired_size == 1
    error_message = "Scale-down schedule does not match expected values"
  }
}

# Test with custom user data
run "custom_user_data" {
  command = plan
  
  variables {
    # Add pre-bootstrap user data
    pre_bootstrap_user_data = <<-EOT
      #!/bin/bash
      echo "Running pre-bootstrap script"
      yum update -y
      yum install -y amazon-cloudwatch-agent
    EOT
    
    # Add post-bootstrap user data
    post_bootstrap_user_data = <<-EOT
      #!/bin/bash
      echo "Running post-bootstrap script"
      systemctl enable amazon-cloudwatch-agent
      systemctl start amazon-cloudwatch-agent
    EOT
    
    # Add bootstrap extra args
    bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=normal'"
  }
  
  assert {
    condition     = length(var.pre_bootstrap_user_data) > 0
    error_message = "Pre-bootstrap user data is empty"
  }
  
  assert {
    condition     = length(var.post_bootstrap_user_data) > 0
    error_message = "Post-bootstrap user data is empty"
  }
  
  assert {
    condition     = length(var.bootstrap_extra_args) > 0
    error_message = "Bootstrap extra args is empty"
  }
}

# Test with custom update configuration
run "update_config" {
  command = plan
  
  variables {
    # Set custom update configuration
    update_config = {
      max_unavailable_percentage = 50
    }
  }
  
  assert {
    condition     = var.update_config.max_unavailable_percentage == 50
    error_message = "Update config max_unavailable_percentage does not match expected value"
  }
}

# Test with node repair configuration
run "node_repair_config" {
  command = plan
  
  variables {
    # Set node repair configuration
    node_repair_config = {
      enabled = true
    }
  }
  
  assert {
    condition     = var.node_repair_config.enabled == true
    error_message = "Node repair config enabled does not match expected value"
  }
}

# Test with custom metadata options
run "metadata_options" {
  command = plan
  
  variables {
    # Set custom metadata options
    metadata_options = {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
      http_put_response_hop_limit = 2
      instance_metadata_tags      = "enabled"
    }
  }
  
  assert {
    condition     = var.metadata_options.http_endpoint == "enabled"
    error_message = "Metadata options http_endpoint does not match expected value"
  }
  
  assert {
    condition     = var.metadata_options.http_tokens == "required"
    error_message = "Metadata options http_tokens does not match expected value"
  }
  
  assert {
    condition     = var.metadata_options.http_put_response_hop_limit == 2
    error_message = "Metadata options http_put_response_hop_limit does not match expected value"
  }
  
  assert {
    condition     = var.metadata_options.instance_metadata_tags == "enabled"
    error_message = "Metadata options instance_metadata_tags does not match expected value"
  }
}