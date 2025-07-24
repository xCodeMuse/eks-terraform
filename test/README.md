# AWS EKS Module Tests

This directory contains tests for the AWS EKS Terraform module. The tests validate the functionality of the module and ensure that it creates the expected resources with the correct configurations.

## Prerequisites

Before running the tests, ensure you have the following:

1. **AWS Credentials**: Configure your AWS credentials with sufficient permissions to create EKS clusters and related resources.

2. **Terraform**: Install Terraform CLI version 1.3.2 or later.

3. **Required Providers**: The tests use the following providers:
   - AWS Provider (>= 5.95, < 6.0.0)
   - TLS Provider (>= 3.0)
   - Time Provider (>= 0.9)

4. **AWS CLI**: Install the AWS CLI for additional validation.

5. **Service Quotas**: Ensure your AWS account has sufficient service quotas for:
   - EKS Clusters
   - EC2 Instances
   - VPCs and related networking resources

## Test Structure

The test directory contains the following files:

- `main.tf`: The main Terraform configuration that creates the test resources
- `variables.tf`: Input variables for the test configuration
- `outputs.tf`: Output values used for validation
- `basic.tftest.hcl`: Test cases that validate the module functionality
- `Makefile`: Helper commands for running the tests

## Running the Tests

You can use the provided Makefile to run the tests:

```bash
# Initialize Terraform
make init

# Validate the Terraform configuration
make validate

# Run all tests
make test

# Run basic test groups
make test-basic
make test-node-groups
make test-fargate
make test-oidc
make test-security-groups

# Run advanced test groups
make test-ipv6
make test-private-endpoint
make test-custom-sg
make test-custom-addons
make test-custom-node-groups
make test-custom-fargate

# Run mock tests (no actual AWS resources created)
make test-mock          # Run all mock tests
make test-mock-module   # Run mock module configuration tests
make test-mock-cluster  # Run mock cluster configuration tests
make test-mock-node-groups # Run mock node group configuration tests
make test-mock-fargate  # Run mock Fargate profile configuration tests
make test-mock-addons   # Run mock add-on configuration tests
make test-mock-security-groups # Run mock security group configuration tests
make test-mock-iam      # Run mock IAM role configuration tests

# Run all tests of a specific type
make test-all-basic
make test-all-advanced

# Alternatively, use the provided shell scripts
./run_tests.sh basic     # Run all basic tests
./run_tests.sh advanced  # Run all advanced tests
./run_tests.sh all       # Run all tests
./run_mock_tests.sh      # Run all mock tests

# Clean up Terraform files
make clean
```

## Test Cases

This test suite includes both unit tests and functional tests to provide comprehensive validation of the AWS EKS module.

### Unit Tests vs. Functional Tests

| Characteristic | Unit Tests | Functional Tests |
|----------------|------------|------------------|
| Resources Created | No actual AWS resources | Real AWS resources |
| Execution Speed | Fast (seconds) | Slow (minutes) |
| Cost | Free | Incurs AWS charges |
| Validation Scope | Configuration syntax and structure | End-to-end functionality |
| Dependencies | Mocked | Real |
| Command | `plan` | `apply` |
| CI/CD Friendly | Yes, no credentials needed | Requires AWS credentials |

### Unit Tests (Mock Tests)

The mock tests (`mock_test.tftest.hcl`) are **unit tests** because they validate the module configuration without creating actual AWS resources:

1. **Module Configuration**: Validates the basic module structure and dependencies.
   ```hcl
   run "validate_module_configuration" {
     command = plan
     assert {
       condition     = length(module.vpc) > 0
       error_message = "VPC module not configured correctly"
     }
   }
   ```

2. **Cluster Configuration**: Verifies the EKS cluster configuration parameters.
   ```hcl
   run "validate_cluster_configuration" {
     command = plan
     assert {
       condition     = module.eks.cluster_version == "1.29"
       error_message = "Cluster version should be 1.29"
     }
   }
   ```

3. **Node Group Configuration**: Checks the EKS managed node group configurations.
   ```hcl
   run "validate_node_group_configuration" {
     command = plan
     assert {
       condition     = length(module.eks.eks_managed_node_groups) == 2
       error_message = "Should have 2 EKS managed node groups"
     }
   }
   ```

4. **Fargate Profile Configuration**: Validates the Fargate profile configurations.
5. **Add-on Configuration**: Verifies the EKS add-on configurations.
6. **Security Group Configuration**: Checks the security group configurations.
7. **IAM Role Configuration**: Validates the IAM role configurations.

These unit tests are useful for:
- Quick validation during development
- CI/CD pipelines where creating actual resources is not feasible
- Validating configuration without incurring AWS costs

### Functional Tests

The basic and advanced tests (`basic.tftest.hcl` and `advanced.tftest.hcl`) are **functional tests** because they create actual AWS resources and validate their behavior:

#### Basic Functional Tests

1. **Basic Cluster Creation**: Verifies that the EKS cluster is created successfully with the correct configuration.
   ```hcl
   run "validate_cluster_creation" {
     command = apply
     assert {
       condition     = module.eks.cluster_status == "ACTIVE"
       error_message = "EKS cluster is not active"
     }
   }
   ```

2. **Node Groups**: Validates the creation and configuration of EKS managed node groups.
   ```hcl
   run "validate_node_groups" {
     command = apply
     assert {
       condition     = length(module.eks.eks_managed_node_groups) > 0
       error_message = "No EKS managed node groups created"
     }
   }
   ```

3. **Fargate Profiles**: Checks that Fargate profiles are created correctly.
4. **OIDC Provider**: Ensures the OIDC provider for IAM Roles for Service Accounts (IRSA) is set up properly.
5. **Security Groups**: Validates the security group configurations for the cluster and nodes.

#### Advanced Functional Tests

1. **IPv6 Configuration**: Tests the module with IPv6 networking enabled.
2. **Private-Only Endpoint**: Tests the module with only private API endpoint access.
3. **Custom Security Group Rules**: Tests the module with custom security group rules.
4. **Custom Add-ons**: Tests the module with custom EKS add-on configurations.
5. **Custom Node Groups**: Tests the module with various node group configurations including spot instances and GPU nodes.
6. **Custom Fargate Profiles**: Tests the module with multiple Fargate profile configurations.

These functional tests provide comprehensive validation of the module's behavior in a real AWS environment, ensuring that resources are created correctly and function as expected.

## Test Environment Variables

You can customize the test execution with the following environment variables:

- `REGION`: AWS region to use for the tests (default: us-west-2)
- `TEST_TIMEOUT`: Timeout for the tests (default: 60m)
- `TEST_FILTER`: Filter to run specific tests

Example:

```bash
REGION=us-east-1 TEST_TIMEOUT=90m make test
```

## Test Reporting

The test directory includes scripts to help generate and manage test reports:

1. **generate_report.sh**: Creates a test report template with environment information pre-filled
   ```bash
   ./generate_report.sh [output_file]
   ```

2. **run_tests.sh**: Runs tests and generates a report in one step
   ```bash
   ./run_tests.sh [basic|advanced|all]
   ```

3. **run_mock_tests.sh**: Runs mock tests and generates a report
   ```bash
   ./run_mock_tests.sh
   ```

4. **demo_mock_test.sh**: Demonstrates the mock test process with a sample report
   ```bash
   ./demo_mock_test.sh
   ```

5. **manage_reports.sh**: Helps manage test reports
   ```bash
   ./manage_reports.sh [list|archive|cleanup|summary]
   ```

Test reports are saved in the `../docs/test_reports/` directory with timestamps in the filename.

For detailed information about test reports, see [README.md](../docs/test_reports/README.md).

### Mock Test Reports

Mock test reports provide validation of the module configuration without creating actual AWS resources. These reports include:

- Module configuration validation
- Cluster configuration validation
- Node group configuration validation
- Fargate profile configuration validation
- Add-on configuration validation
- Security group configuration validation
- IAM role configuration validation

Mock test reports are particularly useful for:
- Pre-commit validation
- Pull request reviews
- Quick configuration checks

### Demo Script

The `demo_mock_test.sh` script provides a demonstration of the mock test process without requiring any AWS credentials or resources. It:

1. Simulates running the mock tests
2. Shows what the test output would look like
3. Displays a sample test report

This is useful for:
- Understanding the test process
- Seeing what a test report looks like
- Training new team members on the testing approach

## Test Report Structure

The test reports follow a standardized structure to ensure consistency and completeness:

1. **Test Summary**: Overview of the test run, including date, tester, and versions
2. **Environment Details**: Information about the AWS environment used for testing
3. **Test Results**: Detailed results for each test case, organized by category
4. **Performance Metrics**: Timing information for resource creation and destruction
5. **Test Coverage**: Analysis of which module components were tested
6. **Known Limitations**: Documentation of any test gaps or limitations
7. **Conclusion & Next Steps**: Summary of findings and recommendations
8. **Appendices**: Test logs and verification commands

For more information about test reports, see [REPORTS_README.md](./QA_REPORTS_README.md).

## Managing Test Reports

The `manage_reports.sh` script provides tools for managing test reports:

1. **List Reports**: View all test reports in the results directory
   ```bash
   ./manage_reports.sh list
   ```

2. **Archive Reports**: Archive test reports into a compressed file
   ```bash
   ./manage_reports.sh archive
   ```

3. **Clean Up Reports**: Remove old test reports
   ```bash
   ./manage_reports.sh cleanup
   ```

4. **Report Summary**: View a summary of all test reports
   ```bash
   ./manage_reports.sh summary
   ```

This helps maintain an organized test report repository, especially when running tests frequently.

## Important Notes

1. **Resource Costs**: Running these tests will create real AWS resources that may incur costs. Always remember to clean up resources after testing.

2. **Test Duration**: The tests can take a significant amount of time to run (30-60 minutes) due to the time required to create and configure an EKS cluster.

3. **Cleanup**: The tests do not automatically clean up resources. Use `terraform destroy` or the AWS Console to remove resources after testing.

4. **Isolation**: It's recommended to run these tests in a dedicated AWS account or region to avoid conflicts with existing resources.

## Extending the Tests

To add new test cases:

1. Add new assertions to the existing test runs in `basic.tftest.hcl`
2. Or create a new `.tftest.hcl` file for more complex scenarios
3. Update the Makefile with new test targets if needed

## Troubleshooting

If you encounter issues with the tests:

1. Check AWS credentials and permissions
2. Verify service quotas in your AWS account
3. Check the Terraform logs for detailed error messages
4. Ensure your AWS region supports all the required services
5. Verify network connectivity to AWS services

## Additional Resources

- [Terraform Testing Documentation](https://developer.hashicorp.com/terraform/language/tests)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)