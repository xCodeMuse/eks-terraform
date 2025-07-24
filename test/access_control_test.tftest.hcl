# test/access_control_test.tftest.hcl

variables {
  cluster_name = "test-eks-access-control"
  region       = "us-west-2"
}

run "create_cluster" {
  command = apply

  variables {
    cluster_name        = var.cluster_name
    region              = var.region
    vpc_id              = "vpc-1234567890abcdef0"
    subnet_ids          = ["subnet-1234567890abcdef0", "subnet-0fedcba9876543210"]
    create_test_iam_role = true
  }
}

resource "null_resource" "verify_access" {
  count = 1

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region} --alias ${var.cluster_name}"
  }

  depends_on = [run.create_cluster]
}

assert "test_iam_role_exists" {
  # Verify that the test IAM role is created
  condition     = aws_iam_role.test[0].arn != ""
  error_message = "Test IAM role should be created"
}

assert "audit_logging_enabled" {
  # Verify that audit logging is enabled for the cluster
  # Verify that audit logging is enabled for the cluster
  condition     = aws_cloudwatch_log_group.this[0].arn != ""
  error_message = "Audit logging should be enabled for the cluster"
}