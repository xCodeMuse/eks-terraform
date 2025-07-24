# QA Index

This document provides a central index for all QA-related files and resources for the AWS EKS Terraform module.

## Test Strategy

- [Test Strategy Document](test_strategy.md) - Outlines the overall testing approach, tools, and scope.

## Test Cases

### Unit Tests (Mock Tests)

- [Mock Test Configuration](../test/mock_test.tftest.hcl) - Contains test cases for validating module configuration without creating actual AWS resources.

### Functional Tests

- [Basic Tests](../test/basic.tftest.hcl) - Contains basic test cases for validating core functionality.
- [Advanced Tests](../test/advanced.tftest.hcl) - Contains advanced test cases for validating complex configurations and edge cases.
- [Access Control Test](../test/access_control_test.tftest.hcl) - Contains tests for validating access control and permissions.

## Test Implementation

- [Main Test Configuration](../test/main.tf) - The main Terraform configuration used for testing.
- [Test Variables](../test/variables.tf) - Input variables for the test configuration.
- [Test Outputs](../test/outputs.tf) - Output values used for validation.
- [Makefile](../test/Makefile) - Helper commands for running the tests.
- [Run Tests Script](../test/run_tests.sh) - Script to run functional tests and generate a report.
- [Run Mock Tests Script](../test/run_mock_tests.sh) - Script to run mock tests and generate a report.
- [Demo Mock Tests Script](../test/demo_mock_test.sh) - Script to demonstrate the mock test process.
- [Manage Reports Script](../test/manage_reports.sh) - Script to manage test reports (list, archive, cleanup, summary).

## Test Reporting

- [Test Report Template](test_reports/test_report_template.md) - Base template for all test reports.
- [Sample Mock Test Report](test_reports/sample_mock_test_report.md) - Sample test report showing expected output.
- [Test Reports Documentation](test_reports/README.md) - Documentation for test reports.

## Module-Specific Test Strategies

- [EKS Managed Node Group Test Strategy](../modules/eks-managed-node-group/test_strategy.md) - Test strategy for the EKS managed node group module.
- [Karpenter Test Strategy](../modules/karpenter/test_strategy.md) - Test strategy for the Karpenter module.

## Module-Specific Test Reports

- [EKS Managed Node Group Test Report](../modules/eks-managed-node-group/test_report.md) - Test report for the EKS managed node group module.
- [Karpenter Test Report](../modules/karpenter/test/test_report.md) - Test report for the Karpenter module.

## Test Execution

- [GitHub Actions Workflow](../.github/workflows/terraform-tests.yml) - CI/CD workflow for automated testing.

## Additional Resources

- [Test Directory README](../test/README.md) - Overview of the test directory structure and usage.
- [Misc Test Strategy](../misc/test_strategy.md) - Additional test strategy documentation.