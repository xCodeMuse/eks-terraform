#!/bin/bash

# Script to run mock tests and generate a report
# Usage: ./run_mock_tests.sh

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print section header
print_header() {
  echo -e "\n${YELLOW}======================================${NC}"
  echo -e "${YELLOW}$1${NC}"
  echo -e "${YELLOW}======================================${NC}\n"
}

# Function to run a test and record the result
run_test() {
  local test_name=$1
  local test_filter=$2
  local start_time=$(date +%s)
  
  echo -e "${YELLOW}Running $test_name...${NC}"
  
  if terraform test -filter="$test_filter" mock_test.tftest.hcl; then
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo -e "${GREEN}✅ $test_name passed in $duration seconds${NC}"
    return 0
  else
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo -e "${RED}❌ $test_name failed after $duration seconds${NC}"
    return 1
  fi
}

# Initialize test results
tests_passed=0
tests_total=7

# Create results directory if it doesn't exist
mkdir -p results

# Initialize Terraform
print_header "Initializing Terraform"
terraform init

# Run mock tests
print_header "Running Mock Tests"

if run_test "Module Configuration" "validate_module_configuration"; then
  ((tests_passed++))
fi

if run_test "Cluster Configuration" "validate_cluster_configuration"; then
  ((tests_passed++))
fi

if run_test "Node Group Configuration" "validate_node_group_configuration"; then
  ((tests_passed++))
fi

if run_test "Fargate Profile Configuration" "validate_fargate_profile_configuration"; then
  ((tests_passed++))
fi

if run_test "Add-on Configuration" "validate_addon_configuration"; then
  ((tests_passed++))
fi

if run_test "Security Group Configuration" "validate_security_group_configuration"; then
  ((tests_passed++))
fi

if run_test "IAM Role Configuration" "validate_iam_role_configuration"; then
  ((tests_passed++))
fi

# Calculate pass percentage
pass_percentage=$(( (tests_passed * 100) / tests_total ))

# Generate test report
print_header "Generating Test Report"

# Create a copy of the template
cp test_report_template.md "results/mock_test_report_$(date +%Y%m%d_%H%M%S).md"
REPORT_FILE="results/mock_test_report_$(date +%Y%m%d_%H%M%S).md"

# Get current date
DATE=$(date +"%Y-%m-%d")

# Get Terraform version
TF_VERSION=$(terraform version -json | jq -r '.terraform_version')

# Get AWS provider version
AWS_PROVIDER_VERSION=$(terraform version -json | jq -r '.provider_selections."registry.terraform.io/hashicorp/aws"')

# Replace placeholders in the template
sed -i "s/\[DATE\]/$DATE/g" "$REPORT_FILE"
sed -i "s/\[NAME\]/Mock Test Runner/g" "$REPORT_FILE"
sed -i "s/\[VERSION\]/Mock Test/g" "$REPORT_FILE"
sed -i "s/\[TERRAFORM VERSION\]/$TF_VERSION/g" "$REPORT_FILE"
sed -i "s/\[AWS PROVIDER VERSION\]/$AWS_PROVIDER_VERSION/g" "$REPORT_FILE"
sed -i "s/\[REGION\]/us-west-2 (Mock)/g" "$REPORT_FILE"
sed -i "s/\[ACCOUNT ID\]/MOCK/g" "$REPORT_FILE"
sed -i "s/\[VPC ID\]/vpc-mock/g" "$REPORT_FILE"
sed -i "s/\[SUBNET IDs\]/subnet-mock-1, subnet-mock-2/g" "$REPORT_FILE"

# Update test results in the report
if [ $tests_passed -eq $tests_total ]; then
  sed -i "s/✅ \/ ❌/✅/g" "$REPORT_FILE"
else
  # Replace specific test results based on our test runs
  # This is a simplified approach - in a real scenario, you'd update each test result individually
  sed -i "s/✅ \/ ❌/❌/g" "$REPORT_FILE"
fi

# Add test summary
echo -e "\n${YELLOW}Mock Tests Summary: ${tests_passed}/${tests_total} tests passed (${pass_percentage}%)${NC}"
echo -e "${YELLOW}Test report generated: ${REPORT_FILE}${NC}"

# Exit with success if all tests passed
if [ $tests_passed -eq $tests_total ]; then
  exit 0
else
  exit 1
fi