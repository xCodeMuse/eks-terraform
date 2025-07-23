# Direct test in the module directory

variables {
  cluster_name        = "test-eks-cluster"
  subnet_ids          = ["subnet-12345678", "subnet-87654321"]
  cluster_endpoint    = "https://test-eks-cluster.eks.amazonaws.com"
  cluster_auth_base64 = "dGVzdC1jbHVzdGVyLWF1dGg="
  cluster_service_cidr = "172.20.0.0/16"
}

run "direct_test" {
  command = plan
  
  assert {
    condition     = var.cluster_name == "test-eks-cluster"
    error_message = "Cluster name does not match expected value"
  }
}