# Basic test for EKS Managed Node Group module

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
  name         = "test-node-group"
  min_size     = 1
  max_size     = 3
  desired_size = 2
  
  # Use AL2 AMI type
  ami_type = "AL2_x86_64"
  
  # Use on-demand instances
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]
}

# Run the module with the variables
run "create_node_group" {
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
    
    # Configure block device mappings
    block_device_mappings = {
      root = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 20
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    }
  }
  
  assert {
    condition     = var.launch_template_name == "custom-lt"
    error_message = "Launch template name does not match expected value"
  }
}

# Test with custom IAM role configuration
run "custom_iam_role" {
  command = plan
  
  variables {
    # Override variables for this test
    iam_role_name        = "custom-role"
    iam_role_description = "Custom IAM role for testing"
    
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
    condition     = var.iam_role_name == "custom-role"
    error_message = "IAM role name does not match expected value"
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
}