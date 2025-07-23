# EKS Managed Node Group Module Tests

This directory contains tests for the EKS Managed Node Group Terraform module.

## Test Structure

- `main.tf` - Contains the mock AWS resources and module configuration
- `basic.tftest.hcl` - Basic functionality tests
- `advanced.tftest.hcl` - Advanced functionality tests

## Test Cases

### Basic Tests

1. **Default Configuration** - Tests the module with default settings
2. **Custom Launch Template** - Tests the module with a custom launch template
3. **Custom IAM Role** - Tests the module with a custom IAM role
4. **Spot Instances** - Tests the module with spot instances

### Advanced Tests

1. **Labels and Taints** - Tests the module with Kubernetes labels and taints
2. **Autoscaling Schedules** - Tests the module with autoscaling schedules
3. **Custom User Data** - Tests the module with custom user data
4. **Update Config** - Tests the module with custom update configuration
5. **Node Repair Config** - Tests the module with node repair configuration
6. **Metadata Options** - Tests the module with custom metadata options

## Running Tests

### Prerequisites

1. Terraform CLI (version 1.5.0 or later)
2. AWS credentials with appropriate permissions (or mock credentials)

### Initialize the Test Directory

```bash
cd modules/eks-managed-node-group/new-tests
terraform init
```

### Run All Tests

```bash
terraform test
```

### Run Specific Tests

To run only the basic tests:

```bash
terraform test -filter=basic.tftest.hcl
```

To run only the advanced tests:

```bash
terraform test -filter=advanced.tftest.hcl
```

### Run Tests with Verbose Output

```bash
terraform test -verbose
```

## Test Approach

These tests use Terraform's built-in testing framework to validate the module's functionality. The tests are designed to:

1. **Validate Input Variables** - Ensure that input variables are correctly passed to the module
2. **Verify Resource Creation** - Check that the module creates the expected resources
3. **Test Configuration Options** - Validate that different configuration options work as expected

The tests use a plan-only approach, which means they validate the Terraform plan without actually creating any resources. This makes the tests faster and safer to run.

## Handling AWS Provider

The tests use a mock AWS provider configuration with `skip_credentials_validation`, `skip_requesting_account_id`, and `skip_metadata_api_check` set to `true`. This allows the tests to run without real AWS credentials.

For running tests in a CI/CD environment, you can either:

1. Use mock credentials as shown in the tests
2. Use a tool like LocalStack to provide a local AWS environment
3. Use real AWS credentials with a dedicated test account

## Adding New Tests

To add a new test:

1. Create a new run block in one of the existing test files or create a new `.tftest.hcl` file
2. Define your variables and assertions
3. Run the test to ensure it passes