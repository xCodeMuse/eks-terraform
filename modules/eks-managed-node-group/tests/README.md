# EKS Managed Node Group Module Tests

This directory contains tests for the EKS Managed Node Group Terraform module.

## Test Files

- `basic.tftest.hcl` - Tests basic functionality of the module
- `advanced.tftest.hcl` - Tests advanced features and configurations
- `mock_module.tf` - Mock AWS resources for testing
- `provider.tf` - AWS provider configuration for testing
- `test_report.md` - Detailed report of testing efforts and results

## Prerequisites

To run these tests, you need:

1. Terraform CLI (version 1.5.0 or later)
2. AWS credentials with appropriate permissions
3. (Optional) LocalStack for local AWS emulation

## Running Tests

### Using Real AWS Environment

1. Configure your AWS credentials:
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_REGION="us-west-2"
   ```

2. Initialize the test directory:
   ```bash
   terraform init
   ```

3. Run the tests:
   ```bash
   terraform test
   ```

### Using LocalStack (Recommended for Development)

1. Start LocalStack:
   ```bash
   docker run -d --name localstack -p 4566:4566 -p 4571:4571 localstack/localstack
   ```

2. Configure your AWS credentials to point to LocalStack:
   ```bash
   export AWS_ACCESS_KEY_ID="test"
   export AWS_SECRET_ACCESS_KEY="test"
   export AWS_REGION="us-west-2"
   export AWS_ENDPOINT_URL="http://localhost:4566"
   ```

3. Initialize the test directory:
   ```bash
   terraform init
   ```

4. Run the tests:
   ```bash
   terraform test
   ```

## Test Structure

### Basic Tests

The basic tests verify the fundamental functionality of the module:

- Creating a node group with default settings
- Using a custom launch template
- Using a custom IAM role
- Using spot instances

### Advanced Tests

The advanced tests verify more complex configurations:

- Using Kubernetes labels and taints
- Configuring autoscaling schedules
- Using custom user data
- Setting custom update configuration
- Enabling node repair
- Configuring metadata options

## Troubleshooting

If you encounter issues with the AWS provider, try the following:

1. Ensure your AWS credentials are correctly configured
2. If using LocalStack, ensure it's running and accessible
3. Check that the AWS region is correctly set
4. Verify that your IAM user/role has the necessary permissions

## Adding New Tests

To add a new test:

1. Create a new `.tftest.hcl` file in this directory
2. Define your variables and test runs
3. Add assertions to verify the expected behavior
4. Update this README.md to document your new test

## Test Report

For a detailed analysis of the testing efforts and results, see the [Test Report](./test_report.md).