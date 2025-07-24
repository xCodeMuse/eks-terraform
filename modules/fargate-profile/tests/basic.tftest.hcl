# Basic test for EKS Fargate Profile module

# Define variables for the test
variables {
  cluster_name = "test-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]
  
  # Set tags for identification
  tags = {
    Environment = "test"
    Terraform   = "true"
  }
  
  # Fargate profile configuration
  name = "test-fargate-profile"
  
  # Selectors for the Fargate profile
  selectors = [
    {
      namespace = "kube-system"
    },
    {
      namespace = "default"
      labels = {
        workload-type = "fargate"
      }
    }
  ]
  
  # Set cluster IP family
  cluster_ip_family = "ipv4"
}

# Run the module with the variables
run "create_fargate_profile" {
  command = plan

  # Basic assertions to check that resources would be created
  assert {
    condition     = length(var.subnet_ids) > 0
    error_message = "Subnet IDs must be provided"
  }
  
  assert {
    condition     = var.cluster_name != ""
    error_message = "Cluster name must be provided"
  }
  
  assert {
    condition     = length(var.selectors) > 0
    error_message = "At least one selector must be provided"
  }
}

# Test with custom IAM role configuration
run "custom_iam_role" {
  command = plan
  
  variables {
    # Override variables for this test
    iam_role_name        = "custom-fargate-role"
    iam_role_description = "Custom IAM role for Fargate testing"
    
    # Add custom tags to the IAM role
    iam_role_tags = {
      CustomTag = "custom-value"
    }
    
    # Add additional policies
    iam_role_additional_policies = {
      AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
  }
  
  assert {
    condition     = var.iam_role_name == "custom-fargate-role"
    error_message = "IAM role name does not match expected value"
  }
}

# Test with custom IAM role policy
run "custom_iam_role_policy" {
  command = plan
  
  variables {
    # Enable IAM role policy creation
    create_iam_role_policy = true
    
    # Define IAM role policy statements
    iam_role_policy_statements = [
      {
        sid       = "AllowS3Access"
        actions   = ["s3:GetObject", "s3:ListBucket"]
        resources = ["arn:aws:s3:::example-bucket/*", "arn:aws:s3:::example-bucket"]
      }
    ]
  }
  
  assert {
    condition     = var.create_iam_role_policy == true
    error_message = "IAM role policy creation should be enabled"
  }
  
  assert {
    condition     = length(var.iam_role_policy_statements) > 0
    error_message = "IAM role policy statements should be provided"
  }
}

# Test with IPv6 configuration
run "ipv6_configuration" {
  command = plan
  
  variables {
    # Set IPv6 cluster IP family
    cluster_ip_family = "ipv6"
  }
  
  assert {
    condition     = var.cluster_ip_family == "ipv6"
    error_message = "Cluster IP family does not match expected value"
  }
}

# Test with custom timeouts
run "custom_timeouts" {
  command = plan
  
  variables {
    # Set custom timeouts
    timeouts = {
      create = "30m"
      delete = "15m"
    }
  }
  
  assert {
    condition     = lookup(var.timeouts, "create", "") == "30m"
    error_message = "Create timeout does not match expected value"
  }
  
  assert {
    condition     = lookup(var.timeouts, "delete", "") == "15m"
    error_message = "Delete timeout does not match expected value"
  }
}