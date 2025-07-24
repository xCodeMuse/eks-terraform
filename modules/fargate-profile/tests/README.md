# EKS Fargate Profile Module Tests

This directory contains tests for the EKS Fargate Profile module using Terraform's built-in test framework.

## Test Structure

- `basic.tftest.hcl`: Basic test cases for the Fargate Profile module
- `fixtures/`: Directory containing mock resources for testing
  - `main.tf`: Main configuration for the test fixtures
  - `variables.tf`: Variables for the test fixtures
  - `outputs.tf`: Outputs from the test fixtures
- `mock_module.tf`: Mock AWS resources for testing
- `provider.tf`: Provider configuration for testing

## Test Cases

The `basic.tftest.hcl` file includes the following test cases:

1. `create_fargate_profile`: Tests the basic creation of a Fargate profile
2. `custom_iam_role`: Tests the creation of a Fargate profile with a custom IAM role
3. `custom_iam_role_policy`: Tests the creation of a Fargate profile with custom IAM role policies
4. `ipv6_configuration`: Tests the creation of a Fargate profile with IPv6 configuration
5. `custom_timeouts`: Tests the creation of a Fargate profile with custom timeouts

## Running the Tests

To run the tests, use the following command from the root of the repository:

```bash
cd modules/fargate-profile/tests
terraform test
```

Or to run a specific test:

```bash
terraform test -filter=create_fargate_profile
```

## Test Environment

The tests use a mock AWS provider with the following configuration:

- Region: us-west-2
- Skip credentials validation: true
- Skip requesting account ID: true
- Skip metadata API check: true
- Access key: mock-access-key
- Secret key: mock-secret-key

This allows the tests to run without actual AWS credentials.

## Test Fixtures

The test fixtures create mock AWS resources for testing:

- Mock VPC
- Mock Subnets
- Mock EKS Cluster
- Mock IAM Role for EKS Cluster
- Mock Security Group

These resources are used by the Fargate Profile module during testing.