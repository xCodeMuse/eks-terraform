# Karpenter Module Tests

This directory contains automated tests for the Karpenter module using Terratest.

## Prerequisites

1. Go 1.16 or later
2. Terraform 1.0.0 or later
3. AWS credentials configured
4. AWS CLI

## Test Structure

- `karpenter_test.go`: Contains the Go test code using Terratest
- `fixtures/`: Contains Terraform configuration files used for testing
  - `main.tf`: Main Terraform configuration for testing
  - `variables.tf`: Input variables for the test configuration
  - `outputs.tf`: Output variables to be tested

## Running Tests

To run the tests, execute the following commands from the `test` directory:

```bash
# Install Go dependencies
go mod init github.com/terraform-aws-modules/terraform-aws-eks/modules/karpenter/test
go mod tidy

# Run the tests
go test -v -timeout 30m
```

## What's Being Tested

The tests validate the following aspects of the Karpenter module:

1. IAM role creation and naming
2. IAM role ARN format
3. SQS queue creation and naming
4. SQS queue URL format

## Cleanup

The tests automatically clean up all created resources using `terraform destroy` after the tests complete, even if the tests fail.

## Notes

- These tests create real AWS resources and may incur costs
- The tests use a random cluster name to prevent naming conflicts
- The tests are designed to be idempotent and can be run multiple times