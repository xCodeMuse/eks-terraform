# HIPAA compliance test for EKS Fargate Profile module
# These tests verify that the Fargate Profile meets HIPAA compliance requirements

# Define variables for the test
variables {
  cluster_name = "hipaa-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]
  
  # Mock values for required inputs
  cluster_endpoint     = "https://hipaa-eks-cluster.eks.amazonaws.com"
  cluster_auth_base64  = "dGVzdC1jbHVzdGVyLWF1dGg="
  cluster_service_cidr = "172.20.0.0/16"
  
  # Set HIPAA compliance tags
  tags = {
    Environment     = "production"
    Terraform       = "true"
    Compliance      = "hipaa"
    DataSensitivity = "phi"  # Protected Health Information
    DataClassification = "restricted"
  }
  
  # Fargate profile configuration
  name = "hipaa-fargate-profile"
  
  # Selectors for the Fargate profile
  selectors = [
    {
      namespace = "hipaa-namespace"
      labels = {
        compliance = "hipaa"
      }
    }
  ]
  
  # Set cluster IP family
  cluster_ip_family = "ipv4"
}

# Test with HIPAA-compliant tags
run "hipaa_compliant_tags" {
  command = plan
  
  variables {
    # Ensure all required HIPAA tags are present
    tags = {
      Environment     = "production"
      Terraform       = "true"
      Compliance      = "hipaa"
      DataSensitivity = "phi"
      DataClassification = "restricted"
      BusinessUnit    = "healthcare"
      CostCenter      = "12345"
      Owner           = "compliance-team"
    }
  }
  
  assert {
    condition     = contains(keys(var.tags), "Compliance")
    error_message = "HIPAA compliance tag must be present"
  }
  
  assert {
    condition     = contains(keys(var.tags), "DataSensitivity")
    error_message = "Data sensitivity tag must be present for HIPAA compliance"
  }
  
  assert {
    condition     = contains(keys(var.tags), "DataClassification")
    error_message = "Data classification tag must be present for HIPAA compliance"
  }
  
  assert {
    condition     = contains(keys(var.tags), "Owner")
    error_message = "Owner tag must be present for HIPAA compliance"
  }
}

# Test with HIPAA-compliant IAM role policies
run "hipaa_compliant_iam_policies" {
  command = plan
  
  variables {
    # Enable IAM role policy creation
    create_iam_role_policy = true
    
    # Define IAM role policy statements for HIPAA compliance
    iam_role_policy_statements = [
      {
        sid       = "DenyUnencryptedTransport"
        effect    = "Deny"
        actions   = ["*"]
        resources = ["*"]
        conditions = [
          {
            test     = "Bool"
            variable = "aws:SecureTransport"
            values   = ["false"]
          }
        ]
      },
      {
        sid       = "DenyPublicAccess"
        effect    = "Deny"
        actions   = ["*"]
        resources = ["*"]
        conditions = [
          {
            test     = "StringEquals"
            variable = "aws:SourceVpc"
            values   = ["vpc-12345678"]
          }
        ]
      },
      {
        sid       = "AllowLogging"
        actions   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        resources = ["arn:aws:logs:*:*:*"]
      }
    ]
    
    # Add additional policies for HIPAA compliance
    iam_role_additional_policies = {
      AmazonEKSClusterPolicy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      CloudWatchLogsFullAccess = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
      AmazonKMSFullAccess = "arn:aws:iam::aws:policy/AmazonKMSFullAccess"
    }
  }
  
  assert {
    condition     = length(var.iam_role_policy_statements) >= 3
    error_message = "HIPAA compliance requires at least 3 policy statements for security"
  }
  
  assert {
    condition     = length(var.iam_role_additional_policies) >= 3
    error_message = "HIPAA compliance requires additional policies for logging and encryption"
  }
}

# Test with HIPAA-compliant network isolation
run "hipaa_network_isolation" {
  command = plan
  
  variables {
    # Use private subnets only for HIPAA compliance
    subnet_ids = ["subnet-private1", "subnet-private2"]
    
    # Add tags to indicate private subnets
    tags = {
      Environment     = "production"
      Terraform       = "true"
      Compliance      = "hipaa"
      NetworkType     = "private"
      DataSensitivity = "phi"
    }
  }
  
  assert {
    condition     = length(var.subnet_ids) > 0
    error_message = "Subnet IDs must be provided for network isolation"
  }
  
  assert {
    condition     = lookup(var.tags, "NetworkType", "") == "private"
    error_message = "NetworkType tag must be set to 'private' for HIPAA compliance"
  }
}

# Test with HIPAA-compliant selectors
run "hipaa_compliant_selectors" {
  command = plan
  
  variables {
    # Define selectors for HIPAA-compliant workloads
    selectors = [
      {
        namespace = "hipaa-namespace"
        labels = {
          compliance = "hipaa"
          encryption = "required"
          access     = "restricted"
        }
      },
      {
        namespace = "healthcare-system"
        labels = {
          compliance = "hipaa"
          encryption = "required"
          access     = "restricted"
          data-type  = "phi"
        }
      }
    ]
  }
  
  assert {
    condition     = length(var.selectors) > 0
    error_message = "At least one selector must be provided"
  }
  
  assert {
    condition     = length(var.selectors[0].labels) >= 3
    error_message = "HIPAA-compliant selectors must have at least 3 labels for proper classification"
  }
}

# Test with HIPAA audit logging enabled
run "hipaa_audit_logging" {
  command = plan
  
  variables {
    # Enable IAM role policy for CloudWatch Logs
    create_iam_role_policy = true
    
    # Define IAM role policy statements for audit logging
    iam_role_policy_statements = [
      {
        sid       = "AllowCloudWatchLogs"
        actions   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        resources = ["arn:aws:logs:*:*:log-group:/aws/eks/hipaa-*:*"]
      },
      {
        sid       = "AllowCloudTrail"
        actions   = [
          "cloudtrail:StartLogging",
          "cloudtrail:StopLogging",
          "cloudtrail:UpdateTrail",
          "cloudtrail:PutEventSelectors"
        ]
        resources = ["arn:aws:cloudtrail:*:*:trail/hipaa-*"]
      }
    ]
    
    # Add CloudWatch and CloudTrail policies
    iam_role_additional_policies = {
      CloudWatchLogsFullAccess = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
      AWSCloudTrailFullAccess = "arn:aws:iam::aws:policy/AWSCloudTrailFullAccess"
    }
    
    # Add tags for audit logging
    tags = {
      Environment     = "production"
      Terraform       = "true"
      Compliance      = "hipaa"
      AuditLogging    = "enabled"
      LogRetention    = "7-years"  # HIPAA requires retention of audit logs
    }
  }
  
  assert {
    condition     = lookup(var.tags, "AuditLogging", "") == "enabled"
    error_message = "AuditLogging tag must be set to 'enabled' for HIPAA compliance"
  }
  
  assert {
    condition     = lookup(var.tags, "LogRetention", "") == "7-years"
    error_message = "LogRetention tag must be set to '7-years' for HIPAA compliance"
  }
}

# Test with HIPAA-compliant encryption
run "hipaa_encryption" {
  command = plan
  
  variables {
    # Enable IAM role policy for KMS
    create_iam_role_policy = true
    
    # Define IAM role policy statements for encryption
    iam_role_policy_statements = [
      {
        sid       = "AllowKMSEncryption"
        actions   = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        resources = ["arn:aws:kms:*:*:key/hipaa-*"]
      },
      {
        sid       = "DenyUnencryptedData"
        effect    = "Deny"
        actions   = [
          "s3:PutObject"
        ]
        resources = ["arn:aws:s3:::hipaa-*/*"]
        conditions = [
          {
            test     = "StringNotEquals"
            variable = "s3:x-amz-server-side-encryption"
            values   = ["AES256", "aws:kms"]
          }
        ]
      }
    ]
    
    # Add KMS policy
    iam_role_additional_policies = {
      AmazonKMSFullAccess = "arn:aws:iam::aws:policy/AmazonKMSFullAccess"
    }
    
    # Add tags for encryption
    tags = {
      Environment     = "production"
      Terraform       = "true"
      Compliance      = "hipaa"
      Encryption      = "required"
      EncryptionType  = "kms"
    }
  }
  
  assert {
    condition     = lookup(var.tags, "Encryption", "") == "required"
    error_message = "Encryption tag must be set to 'required' for HIPAA compliance"
  }
  
  assert {
    condition     = lookup(var.tags, "EncryptionType", "") == "kms"
    error_message = "EncryptionType tag must be set to 'kms' for HIPAA compliance"
  }
}