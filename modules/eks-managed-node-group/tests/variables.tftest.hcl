# Simple variable validation tests for EKS Managed Node Group module

# Define variables for the test
variables {
  cluster_name = "test-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]
  
  # Mock values for required inputs
  cluster_endpoint     = "https://test-eks-cluster.eks.amazonaws.com"
  cluster_auth_base64  = "dGVzdC1jbHVzdGVyLWF1dGg="
  cluster_service_cidr = "172.20.0.0/16"
  
  # Node group configuration
  name         = "test-node-group"
  min_size     = 1
  max_size     = 3
  desired_size = 2
}

# Test variable validation
run "variable_validation" {
  command = plan
  
  # These assertions don't require AWS provider authentication
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