# Terraform EKS Module Test Makefile

.PHONY: init validate test clean

# Default AWS region
REGION ?= us-west-2

# Default test timeout
TEST_TIMEOUT ?= 60m

# Default test filter (empty means run all tests)
TEST_FILTER ?=

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Validate Terraform configuration
validate: init
	@echo "Validating Terraform configuration..."
	terraform validate

# Run Terraform tests
test: init
	@echo "Running Terraform tests..."
	terraform test -timeout=$(TEST_TIMEOUT) $(if $(TEST_FILTER),-filter=$(TEST_FILTER),)

# Run specific test groups
test-basic: init
	@echo "Running basic tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_cluster_creation

test-node-groups: init
	@echo "Running node group tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_node_groups

test-fargate: init
	@echo "Running Fargate tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_fargate_profiles

test-oidc: init
	@echo "Running OIDC provider tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_oidc_provider

test-security-groups: init
	@echo "Running security group tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_security_groups

# Run advanced tests
test-ipv6: init
	@echo "Running IPv6 configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_ipv6_configuration

test-private-endpoint: init
	@echo "Running private endpoint tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_private_only_endpoint

test-custom-sg: init
	@echo "Running custom security group tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_custom_security_group_rules

test-custom-addons: init
	@echo "Running custom add-ons tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_custom_addons

test-custom-node-groups: init
	@echo "Running custom node groups tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_custom_node_groups

test-custom-fargate: init
	@echo "Running custom Fargate profiles tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_custom_fargate_profiles

# Run all basic tests
test-all-basic: init
	@echo "Running all basic tests..."
	terraform test -timeout=$(TEST_TIMEOUT) basic.tftest.hcl

# Run all advanced tests
test-all-advanced: init
	@echo "Running all advanced tests..."
	terraform test -timeout=$(TEST_TIMEOUT) advanced.tftest.hcl

# Run mock tests
test-mock: init
	@echo "Running mock tests..."
	./run_mock_tests.sh

# Run demo mock tests
demo-mock: init
	@echo "Running mock test demo..."
	./demo_mock_test.sh

# Run specific mock tests
test-mock-module: init
	@echo "Running mock module configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_module_configuration mock_test.tftest.hcl

test-mock-cluster: init
	@echo "Running mock cluster configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_cluster_configuration mock_test.tftest.hcl

test-mock-node-groups: init
	@echo "Running mock node group configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_node_group_configuration mock_test.tftest.hcl

test-mock-fargate: init
	@echo "Running mock Fargate profile configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_fargate_profile_configuration mock_test.tftest.hcl

test-mock-addons: init
	@echo "Running mock add-on configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_addon_configuration mock_test.tftest.hcl

test-mock-security-groups: init
	@echo "Running mock security group configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_security_group_configuration mock_test.tftest.hcl

test-mock-iam: init
	@echo "Running mock IAM role configuration tests..."
	terraform test -timeout=$(TEST_TIMEOUT) -filter=validate_iam_role_configuration mock_test.tftest.hcl

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

# Help command
help:
	@echo "Available commands:"
	@echo "  make init              - Initialize Terraform"
	@echo "  make validate          - Validate Terraform configuration"
	@echo "  make test              - Run all Terraform tests"
	@echo "  make test-basic        - Run basic cluster tests"
	@echo "  make test-node-groups  - Run node group tests"
	@echo "  make test-fargate      - Run Fargate tests"
	@echo "  make test-oidc         - Run OIDC provider tests"
	@echo "  make test-security-groups - Run security group tests"
	@echo "  make test-ipv6         - Run IPv6 configuration tests"
	@echo "  make test-private-endpoint - Run private endpoint tests"
	@echo "  make test-custom-sg    - Run custom security group tests"
	@echo "  make test-custom-addons - Run custom add-ons tests"
	@echo "  make test-custom-node-groups - Run custom node groups tests"
	@echo "  make test-custom-fargate - Run custom Fargate profiles tests"
	@echo "  make test-all-basic    - Run all basic tests"
	@echo "  make test-all-advanced - Run all advanced tests"
	@echo "  make test-mock         - Run all mock tests"
	@echo "  make demo-mock         - Run mock test demo"
	@echo "  make test-mock-module  - Run mock module configuration tests"
	@echo "  make test-mock-cluster - Run mock cluster configuration tests"
	@echo "  make test-mock-node-groups - Run mock node group configuration tests"
	@echo "  make test-mock-fargate - Run mock Fargate profile configuration tests"
	@echo "  make test-mock-addons  - Run mock add-on configuration tests"
	@echo "  make test-mock-security-groups - Run mock security group configuration tests"
	@echo "  make test-mock-iam     - Run mock IAM role configuration tests"
	@echo "  make clean             - Clean up Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  REGION                 - AWS region (default: us-west-2)"
	@echo "  TEST_TIMEOUT           - Test timeout (default: 60m)"
	@echo "  TEST_FILTER            - Test filter (default: empty, run all tests)"