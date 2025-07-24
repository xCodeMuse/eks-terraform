#!/bin/bash

# Script to demonstrate the mock test process
# This script simulates running the mock tests and displays the sample report

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section header
print_header() {
  echo -e "\n${YELLOW}======================================${NC}"
  echo -e "${YELLOW}$1${NC}"
  echo -e "${YELLOW}======================================${NC}\n"
}

# Function to simulate running a test
simulate_test() {
  local test_name=$1
  local duration=$2
  
  echo -e "${YELLOW}Running $test_name...${NC}"
  sleep $duration
  echo -e "${GREEN}✅ $test_name passed in $duration seconds${NC}"
}

# Create reports directory if it doesn't exist
mkdir -p ../docs/test_reports

# Print introduction
print_header "EKS Module Mock Test Demo"
echo -e "This script demonstrates the mock test process for the AWS EKS module."
echo -e "It simulates running the mock tests and displays the sample report."
echo -e "\nPress Enter to continue..."
read

# Simulate initializing Terraform
print_header "Initializing Terraform"
echo -e "${BLUE}terraform init${NC}"
sleep 2
echo -e "${GREEN}Terraform has been successfully initialized!${NC}"
echo -e "\nPress Enter to continue..."
read

# Simulate running mock tests
print_header "Running Mock Tests"

simulate_test "Module Configuration" 2
simulate_test "Cluster Configuration" 1
simulate_test "Node Group Configuration" 2
simulate_test "Fargate Profile Configuration" 1
simulate_test "Add-on Configuration" 1
simulate_test "Security Group Configuration" 2
simulate_test "IAM Role Configuration" 1

# Calculate pass percentage
tests_passed=7
tests_total=7
pass_percentage=$(( (tests_passed * 100) / tests_total ))

# Print test summary
echo -e "\n${YELLOW}Mock Tests Summary: ${tests_passed}/${tests_total} tests passed (${pass_percentage}%)${NC}"
echo -e "\nPress Enter to continue..."
read

# Simulate generating test report
print_header "Generating Test Report"
echo -e "${BLUE}Generating test report...${NC}"
sleep 2
echo -e "${GREEN}Test report generated: ../docs/test_reports/sample_mock_test_report.md${NC}"
echo -e "\nPress Enter to view the report..."
read

# Open the sample report
print_header "Opening Sample Test Report"
echo -e "${BLUE}Opening sample test report...${NC}"

# Check if we're on macOS or Linux and open the file accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
  open ../docs/test_reports/sample_mock_test_report.md
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v xdg-open &> /dev/null; then
    xdg-open ../docs/test_reports/sample_mock_test_report.md
  else
    echo -e "${YELLOW}Cannot open the file automatically. Please open ../docs/test_reports/sample_mock_test_report.md manually.${NC}"
  fi
else
  echo -e "${YELLOW}Cannot open the file automatically. Please open ../docs/test_reports/sample_mock_test_report.md manually.${NC}"
fi

echo -e "\n${GREEN}Demo completed!${NC}"
echo -e "You can run the actual mock tests with: ${BLUE}./run_mock_tests.sh${NC}"