# EKS Root Module Tests

This directory contains tests for the EKS root module using Terraform's built-in test framework and Terratest.

## Directory Structure

```
test/
├── fixtures/
│   ├── basic/              # Basic EKS cluster configuration
│   ├── node_groups/        # EKS cluster with managed node groups
│   ├── fargate/            # EKS cluster with Fargate profiles
│   └── full/               # Complete EKS cluster with all features
├── terratest/              # Terratest Go files (for complex scenarios)
├── basic.tftest.hcl        # Basic Terraform tests
└── README.md               # This file
```

## Prerequisites

- Terraform 1.6.0 or later
- AWS CLI configured with appropriate credentials
- Go 1.16 or later (for Terratest)

## Running Terraform Tests

To run the Terraform tests, use the following command from the root of the repository:

```bash
terraform test test/basic.tftest.hcl
```

This will run all the test runs defined in the `basic.tftest.hcl` file.

To run a specific test run, use the `-run` flag:

```bash
terraform test test/basic.tftest.hcl -run=create_basic_cluster
```

## Running Terratest Tests

To run the Terratest tests, navigate to the `test/terratest` directory and run:

```bash
cd test/terratest
go test -v
```

## Test Fixtures

The test fixtures are located in the `fixtures` directory. Each fixture represents a different configuration of the EKS module:

- `basic`: A basic EKS cluster with minimal configuration
- `node_groups`: An EKS cluster with managed node groups
- `fargate`: An EKS cluster with Fargate profiles
- `full`: A complete EKS cluster with all features enabled

## Adding New Tests

### Adding a New Terraform Test

1. Create a new `.tftest.hcl` file in the `test` directory
2. Define variables and test runs in the file
3. Run the test using `terraform test test/your-test.tftest.hcl`

### Adding a New Terratest Test

1. Create a new Go test file in the `test/terratest` directory
2. Implement the test using the Terratest framework
3. Run the test using `go test -v`

## Test Coverage

The tests cover the following aspects of the EKS module:

- Basic cluster creation
- Private/public endpoint configuration
- KMS encryption
- IRSA (IAM Roles for Service Accounts)
- Managed node groups
- Fargate profiles
- Self-managed node groups
- Integration with other AWS services

## Troubleshooting

If you encounter issues running the tests, check the following:

- Ensure you have the correct AWS credentials configured
- Verify that you have the required permissions to create EKS clusters
- Check that you're using a compatible version of Terraform
- For Terratest, ensure you have Go installed and properly configured