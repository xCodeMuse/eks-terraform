# EKS Fargate Profile Module Test Directory Structure

```
modules/fargate-profile/
├── main.tf                  # Main module code
├── variables.tf             # Module variables
├── outputs.tf               # Module outputs
├── test_strategy.md         # Test strategy document
└── tests/                   # Test directory
    ├── basic.tftest.hcl     # Basic test cases
    ├── advanced.tftest.hcl  # Advanced test cases
    ├── README.md            # Test documentation
    ├── test_report.md       # Test results report
    ├── provider.tf          # Provider configuration for tests
    ├── mock_module.tf       # Mock AWS resources for testing
    ├── run_mock_tests.sh    # Script to run the tests
    ├── run_mock_tests_simulation.sh  # Script to simulate test runs
    ├── directory_structure.md  # This file
    ├── results/             # Directory for test logs
    │   ├── basic_create.log
    │   ├── basic_iam_role.log
    │   ├── basic_iam_policy.log
    │   ├── basic_ipv6.log
    │   ├── basic_timeouts.log
    │   ├── adv_selectors.log
    │   ├── adv_existing_role.log
    │   ├── adv_complex_role.log
    │   ├── adv_complex_policy.log
    │   └── adv_complex_timeouts.log
    └── fixtures/            # Test fixtures
        ├── main.tf          # Main configuration for fixtures
        ├── variables.tf     # Variables for fixtures
        └── outputs.tf       # Outputs from fixtures
```

## File Descriptions

- **test_strategy.md**: Defines the testing approach, tools, scope, and procedures for validating the module
- **basic.tftest.hcl**: Contains basic test cases for the module
- **advanced.tftest.hcl**: Contains advanced test cases with more complex configurations
- **README.md**: Documentation for the tests, including how to run them
- **test_report.md**: Detailed report of test results and coverage
- **provider.tf**: AWS provider configuration for tests
- **mock_module.tf**: Mock AWS resources for testing
- **run_mock_tests.sh**: Script to run the tests
- **run_mock_tests_simulation.sh**: Script to simulate test runs for demonstration
- **fixtures/main.tf**: Main configuration for test fixtures
- **fixtures/variables.tf**: Variables for test fixtures
- **fixtures/outputs.tf**: Outputs from test fixtures
- **results/**: Directory containing logs from test runs