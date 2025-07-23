# EKS Managed Node Group Module Tests

This directory contains tests for the EKS Managed Node Group Terraform module that actually test the module's functionality.

## Test Approach

These tests use a mock AWS provider configuration that skips credential validation and API calls. This allows us to test the module's functionality without requiring real AWS credentials or resources.

The tests focus on validating:

1. The module's ability to create resources with different configurations
2. The module's outputs and their expected values
3. The module's handling of various input variables

## Test Files

- `main.tf` - Contains the mock AWS provider configuration and module instantiation
- `module.tftest.hcl` - Contains the test cases for the module

## Test Cases

1. **Default Configuration** - Tests the module with default settings
2. **Custom Capacity** - Tests the module with custom capacity settings (SPOT instances, multiple instance types)
3. **Custom Launch Template** - Tests the module with a custom launch template
4. **Custom IAM Role** - Tests the module with a custom IAM role
5. **Labels and Taints** - Tests the module with Kubernetes labels and taints
6. **Autoscaling Schedules** - Tests the module with autoscaling schedules

## Running Tests

### Prerequisites

1. Terraform CLI (version 1.5.0 or later)
2. LocalStack running locally (optional, for more realistic testing)

### Initialize the Test Directory

```bash
cd modules/eks-managed-node-group/module-test
terraform init
```

### Run All Tests

```bash
terraform test
```

### Run Specific Tests

```bash
terraform test -filter="custom_capacity"
```

### Run Tests with Verbose Output

```bash
terraform test -verbose
```

## Mock AWS Provider

The tests use a mock AWS provider configuration with:

- `skip_credentials_validation = true`
- `skip_requesting_account_id = true`
- `skip_metadata_api_check = true`
- Mock credentials
- LocalStack endpoints (optional)

This allows the tests to run without real AWS credentials or resources.

## Lifecycle Configuration

The resources in the test configuration use `lifecycle { ignore_changes = all }` to prevent Terraform from making API calls during the plan phase. This ensures that the tests can run without real AWS credentials or resources.

## Assertions

The tests use assertions to validate that:

1. The module's outputs are not null
2. The module's configuration is applied correctly

These assertions ensure that the module is functioning as expected without requiring real AWS resources.