# Advanced test for EKS Managed Node Group module

# Define variables for the test
variables {
  cluster_name = "test-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]
  
  # Mock values for required inputs
  cluster_endpoint     = "https://test-eks-cluster.eks.amazonaws.com"
  cluster_auth_base64  = "dGVzdC1jbHVzdGVyLWF1dGg="
  cluster_service_cidr = "172.20.0.0/16"
  
  # Set tags for identification
  tags = {
    Environment = "test"
    Terraform   = "true"
  }
  
  # Node group configuration
  name         = "test-node-group-advanced"
  min_size     = 2
  max_size     = 5
  desired_size = 3
  
  # Use AL2023 AMI type
  ami_type = "AL2023_x86_64_STANDARD"
  
  # Use on-demand instances
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.large"]
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
  
  assert {
    condition     = length(var.labels) > 0
    error_message = "Labels must be provided"
  }
  
  assert {
    condition     = length(var.taints) > 0
    error_message = "Taints must be provided"
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
    error_message = "Create schedule must be enabled"
  }
  
  assert {
    condition     = length(var.schedules) > 0
    error_message = "Schedules must be provided"
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
    error_message = "Pre-bootstrap user data must be provided"
  }
  
  assert {
    condition     = length(var.post_bootstrap_user_data) > 0
    error_message = "Post-bootstrap user data must be provided"
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
    condition     = lookup(var.update_config, "max_unavailable_percentage", 0) == 50
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
    condition     = lookup(var.node_repair_config, "enabled", false) == true
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
    condition     = lookup(var.metadata_options, "http_tokens", "") == "required"
    error_message = "Metadata options http_tokens does not match expected value"
  }
  
  assert {
    condition     = lookup(var.metadata_options, "instance_metadata_tags", "") == "enabled"
    error_message = "Metadata options instance_metadata_tags does not match expected value"
  }
}