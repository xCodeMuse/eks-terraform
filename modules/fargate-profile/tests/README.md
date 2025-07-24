# EKS Fargate Profile Module Tests

This directory contains tests for the EKS Fargate Profile module using Terraform's built-in test framework.

## Test Structure

- `basic.tftest.hcl`: Basic test cases for the Fargate Profile module
- `advanced.tftest.hcl`: Advanced test cases with more complex configurations
- `hipaa.tftest.hcl`: HIPAA compliance test cases for healthcare environments
- `fixtures/`: Directory containing mock resources for testing
  - `main.tf`: Main configuration for the test fixtures
  - `variables.tf`: Variables for the test fixtures
  - `outputs.tf`: Outputs from the test fixtures
- `mock_module.tf`: Mock AWS resources for testing
- `provider.tf`: Provider configuration for testing
- `Makefile`: Makefile for running tests
- `run_mock_tests.sh`: Script for running tests and generating a report
- `run_mock_tests_simulation.sh`: Script for simulating tests (for demonstration)
- `results/`: Directory for test logs
- `directory_structure.md`: Overview of the test directory structure
- `test_report.md`: Detailed test results and coverage

## Test Cases

### Basic Tests (`basic.tftest.hcl`)

1. `create_fargate_profile`: Tests the basic creation of a Fargate profile
2. `custom_iam_role`: Tests the creation of a Fargate profile with a custom IAM role
3. `custom_iam_role_policy`: Tests the creation of a Fargate profile with custom IAM role policies
4. `ipv6_configuration`: Tests the creation of a Fargate profile with IPv6 configuration
5. `custom_timeouts`: Tests the creation of a Fargate profile with custom timeouts

### Advanced Tests (`advanced.tftest.hcl`)

1. `multiple_selectors`: Tests the creation of a Fargate profile with multiple selectors with complex label combinations
2. `existing_iam_role`: Tests the creation of a Fargate profile with an existing IAM role
3. `complex_iam_role`: Tests the creation of a Fargate profile with a complex IAM role configuration
4. `complex_iam_role_policy`: Tests the creation of a Fargate profile with complex IAM role policies
5. `complex_timeouts`: Tests the creation of a Fargate profile with complex timeouts

### HIPAA Compliance Tests (`hipaa.tftest.hcl`)

1. `hipaa_compliant_tags`: Tests the creation of a Fargate profile with HIPAA-compliant tags
2. `hipaa_compliant_iam_policies`: Tests the creation of a Fargate profile with HIPAA-compliant IAM policies
3. `hipaa_network_isolation`: Tests the creation of a Fargate profile with HIPAA-compliant network isolation
4. `hipaa_compliant_selectors`: Tests the creation of a Fargate profile with HIPAA-compliant selectors
5. `hipaa_audit_logging`: Tests the creation of a Fargate profile with HIPAA-compliant audit logging
6. `hipaa_encryption`: Tests the creation of a Fargate profile with HIPAA-compliant encryption

## Running the Tests

### Using the Makefile

The Makefile provides several targets for running tests:

```bash
# Run all tests
make test

# Run only basic tests
make test-basic

# Run only advanced tests
make test-advanced

# Run only HIPAA compliance tests
make test-hipaa

# Run tests and generate a report
make test-report

# Simulate tests (for demonstration)
make simulate-tests

# Clean up test results
make clean

# Initialize Terraform
make init

# Show help
make help
```

### Using Terraform Directly

To run the tests directly with Terraform:

```bash
# Run all tests
terraform test

# Run a specific test
terraform test -filter=create_fargate_profile

# Run all HIPAA compliance tests
terraform test -filter=hipaa_
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

## HIPAA Compliance Testing

The HIPAA compliance tests ensure that the Fargate Profile module can be used in healthcare environments where protected health information (PHI) is processed. These tests validate:

1. **Proper Tagging**: Required tags for HIPAA compliance tracking and data classification
2. **IAM Policies**: Secure access controls and encryption requirements
3. **Network Isolation**: Private subnet configuration for PHI protection
4. **Audit Logging**: Required logging for compliance tracking and monitoring
5. **Encryption**: KMS encryption for sensitive healthcare data
6. **Kubernetes Configuration**: Proper namespace and label configuration for healthcare workloads

For detailed information on the HIPAA compliance tests, see the `hipaa.tftest.hcl` file and the test report.

## Test Report

After running the tests, a test report is generated in `test_report.md`. This report includes:

- A summary of all test cases and their status
- Detailed information about each test case
- Test coverage information
- Recommendations for additional testing

To view the latest test report, see [test_report.md](test_report.md).