# Advanced test for EKS Fargate Profile module

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
  name = "test-fargate-profile-advanced"
  
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

# Test with multiple selectors with complex label combinations
run "multiple_selectors" {
  command = plan
  
  variables {
    # Define multiple selectors with complex label combinations
    selectors = [
      {
        namespace = "kube-system"
      },
      {
        namespace = "default"
        labels = {
          workload-type = "fargate"
          environment   = "test"
          app           = "example"
        }
      },
      {
        namespace = "application"
        labels = {
          tier          = "backend"
          cost-center   = "platform"
          criticality   = "high"
        }
      }
    ]
  }
  
  assert {
    condition     = length(var.selectors) == 3
    error_message = "Number of selectors does not match expected value"
  }
  
  assert {
    condition     = length(var.selectors[1].labels) == 3
    error_message = "Number of labels in second selector does not match expected value"
  }
  
  assert {
    condition     = length(var.selectors[2].labels) == 3
    error_message = "Number of labels in third selector does not match expected value"
  }
}

# Test with existing IAM role
run "existing_iam_role" {
  command = plan
  
  variables {
    # Use an existing IAM role
    create_iam_role = false
    iam_role_arn    = "arn:aws:iam::123456789012:role/existing-fargate-role"
  }
  
  assert {
    condition     = var.create_iam_role == false
    error_message = "Create IAM role should be disabled"
  }
  
  assert {
    condition     = var.iam_role_arn != null
    error_message = "IAM role ARN must be provided when create_iam_role is false"
  }
}

# Test with complex IAM role configuration
run "complex_iam_role" {
  command = plan
  
  variables {
    # Set complex IAM role configuration
    iam_role_name              = "complex-fargate-role"
    iam_role_use_name_prefix   = false
    iam_role_path              = "/eks/fargate/"
    iam_role_description       = "Complex IAM role for Fargate testing"
    iam_role_permissions_boundary = "arn:aws:iam::123456789012:policy/PermissionsBoundary"
    
    # Add custom tags to the IAM role
    iam_role_tags = {
      CustomTag  = "custom-value"
      Department = "Platform"
      Owner      = "EKS Team"
      CostCenter = "123456"
    }
    
    # Add additional policies
    iam_role_additional_policies = {
      AmazonS3ReadOnlyAccess     = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      AmazonDynamoDBReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
      CloudWatchLogsFullAccess   = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    }
  }
  
  assert {
    condition     = var.iam_role_path == "/eks/fargate/"
    error_message = "IAM role path does not match expected value"
  }
  
  assert {
    condition     = length(var.iam_role_tags) == 4
    error_message = "Number of IAM role tags does not match expected value"
  }
  
  assert {
    condition     = length(var.iam_role_additional_policies) == 3
    error_message = "Number of additional policies does not match expected value"
  }
}

# Test with complex IAM role policy
run "complex_iam_role_policy" {
  command = plan
  
  variables {
    # Enable IAM role policy creation
    create_iam_role_policy = true
    
    # Define complex IAM role policy statements
    iam_role_policy_statements = [
      {
        sid       = "AllowS3Access"
        actions   = ["s3:GetObject", "s3:ListBucket"]
        resources = ["arn:aws:s3:::example-bucket/*", "arn:aws:s3:::example-bucket"]
      },
      {
        sid       = "AllowDynamoDBAccess"
        actions   = ["dynamodb:GetItem", "dynamodb:Query", "dynamodb:Scan"]
        resources = ["arn:aws:dynamodb:*:*:table/example-table"]
      },
      {
        sid       = "AllowSQSAccess"
        actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        resources = ["arn:aws:sqs:*:*:example-queue"]
      }
    ]
  }
  
  assert {
    condition     = length(var.iam_role_policy_statements) == 3
    error_message = "Number of IAM role policy statements does not match expected value"
  }
}

# Test with complex timeouts
run "complex_timeouts" {
  command = plan
  
  variables {
    # Set complex timeouts
    timeouts = {
      create = "45m"
      delete = "30m"
    }
  }
  
  assert {
    condition     = lookup(var.timeouts, "create", "") == "45m"
    error_message = "Create timeout does not match expected value"
  }
  
  assert {
    condition     = lookup(var.timeouts, "delete", "") == "30m"
    error_message = "Delete timeout does not match expected value"
  }
}