# Makefile for EKS Fargate Profile module tests

.PHONY: test test-basic test-advanced test-hipaa clean simulate-tests

# Default target
all: test

# Run all tests
test: test-basic test-advanced test-hipaa

# Run basic tests
test-basic:
	@echo "Running basic tests..."
	terraform -chdir=. test -filter=create_fargate_profile -verbose
	terraform -chdir=. test -filter=custom_iam_role -verbose
	terraform -chdir=. test -filter=custom_iam_role_policy -verbose
	terraform -chdir=. test -filter=ipv6_configuration -verbose
	terraform -chdir=. test -filter=custom_timeouts -verbose

# Run advanced tests
test-advanced:
	@echo "Running advanced tests..."
	terraform -chdir=. test -filter=multiple_selectors -verbose
	terraform -chdir=. test -filter=existing_iam_role -verbose
	terraform -chdir=. test -filter=complex_iam_role -verbose
	terraform -chdir=. test -filter=complex_iam_role_policy -verbose
	terraform -chdir=. test -filter=complex_timeouts -verbose

# Run HIPAA compliance tests
test-hipaa:
	@echo "Running HIPAA compliance tests..."
	terraform -chdir=. test -filter=hipaa_compliant_tags -verbose
	terraform -chdir=. test -filter=hipaa_compliant_iam_policies -verbose
	terraform -chdir=. test -filter=hipaa_network_isolation -verbose
	terraform -chdir=. test -filter=hipaa_compliant_selectors -verbose
	terraform -chdir=. test -filter=hipaa_audit_logging -verbose
	terraform -chdir=. test -filter=hipaa_encryption -verbose

# Run all tests and generate a report
test-report: clean
	@echo "Running tests and generating report..."
	./run_mock_tests.sh

# Simulate tests (for demonstration)
simulate-tests: clean
	@echo "Simulating tests..."
	./run_mock_tests_simulation.sh

# Clean up test results
clean:
	@echo "Cleaning up test results..."
	rm -rf results
	mkdir -p results

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform -chdir=. init

# Help
help:
	@echo "Available targets:"
	@echo "  all            - Run all tests (default)"
	@echo "  test           - Run all tests"
	@echo "  test-basic     - Run basic tests"
	@echo "  test-advanced  - Run advanced tests"
	@echo "  test-hipaa     - Run HIPAA compliance tests"
	@echo "  test-report    - Run tests and generate a report"
	@echo "  simulate-tests - Simulate tests (for demonstration)"
	@echo "  clean          - Clean up test results"
	@echo "  init           - Initialize Terraform"
	@echo "  help           - Show this help message"