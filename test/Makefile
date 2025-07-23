.PHONY: test test-terraform test-terratest clean

# Default target
all: test

# Run all tests
test: test-terraform test-terratest

# Run Terraform tests
test-terraform:
	@echo "Running Terraform tests..."
	terraform -chdir=.. test test/basic.tftest.hcl

# Run specific Terraform test
test-terraform-run:
	@echo "Running specific Terraform test: $(RUN)"
	terraform -chdir=.. test test/basic.tftest.hcl -run=$(RUN)

# Run Terratest tests
test-terratest:
	@echo "Running Terratest tests..."
	cd terratest && go test -v

# Run specific Terratest test
test-terratest-run:
	@echo "Running specific Terratest test: $(RUN)"
	cd terratest && go test -v -run $(RUN)

# Clean up test artifacts
clean:
	@echo "Cleaning up test artifacts..."
	rm -rf terratest/vendor
	find . -name ".terraform" -type d -exec rm -rf {} +
	find . -name ".terraform.lock.hcl" -type f -delete
	find . -name "terraform.tfstate*" -type f -delete
	find . -name "crash.log" -type f -delete

# Initialize test environment
init:
	@echo "Initializing test environment..."
	cd terratest && go mod tidy
	terraform -chdir=fixtures/basic init
	terraform -chdir=fixtures/node_groups init
	terraform -chdir=fixtures/fargate init
	terraform -chdir=fixtures/full init

# Help target
help:
	@echo "Available targets:"
	@echo "  all               Run all tests (default)"
	@echo "  test              Run all tests"
	@echo "  test-terraform    Run Terraform tests"
	@echo "  test-terraform-run RUN=<test_name>  Run specific Terraform test"
	@echo "  test-terratest    Run Terratest tests"
	@echo "  test-terratest-run RUN=<test_name>  Run specific Terratest test"
	@echo "  clean             Clean up test artifacts"
	@echo "  init              Initialize test environment"
	@echo "  help              Show this help message"