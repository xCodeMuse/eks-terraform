#!/bin/bash

# Script to run all tests and generate a report
# Usage: ./run_tests.sh [basic|advanced|all]

# Default test type
TEST_TYPE=${1:-"all"}

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
  local make_target=$2
  local start_time=$(date +%s)
  
  echo -e "${YELLOW}Running $test_name...${NC}"
  
  if make $make_target; then
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
basic_tests_passed=0
basic_tests_total=5
advanced_tests_passed=0
advanced_tests_total=6

# Create results directory if it doesn't exist
mkdir -p results

# Run basic tests
run_basic_tests() {
  print_header "Running Basic Tests"
  
  if run_test "Basic Cluster Creation" "test-basic"; then
    ((basic_tests_passed++))
  fi
  
  if run_test "Node Groups" "test-node-groups"; then
    ((basic_tests_passed++))
  fi
  
  if run_test "Fargate Profiles" "test-fargate"; then
    ((basic_tests_passed++))
  fi
  
  if run_test "OIDC Provider" "test-oidc"; then
    ((basic_tests_passed++))
  fi
  
  if run_test "Security Groups" "test-security-groups"; then
    ((basic_tests_passed++))
  fi
  
  echo -e "\n${YELLOW}Basic Tests Summary: ${basic_tests_passed}/${basic_tests_total} tests passed${NC}"
}

# Run advanced tests
run_advanced_tests() {
  print_header "Running Advanced Tests"
  
  if run_test "IPv6 Configuration" "test-ipv6"; then
    ((advanced_tests_passed++))
  fi
  
  if run_test "Private Endpoint" "test-private-endpoint"; then
    ((advanced_tests_passed++))
  fi
  
  if run_test "Custom Security Groups" "test-custom-sg"; then
    ((advanced_tests_passed++))
  fi
  
  if run_test "Custom Add-ons" "test-custom-addons"; then
    ((advanced_tests_passed++))
  fi
  
  if run_test "Custom Node Groups" "test-custom-node-groups"; then
    ((advanced_tests_passed++))
  fi
  
  if run_test "Custom Fargate Profiles" "test-custom-fargate"; then
    ((advanced_tests_passed++))
  fi
  
  echo -e "\n${YELLOW}Advanced Tests Summary: ${advanced_tests_passed}/${advanced_tests_total} tests passed${NC}"
}

# Generate test report
generate_report() {
  print_header "Generating Test Report"
  
  # Calculate overall results
  total_tests=$((basic_tests_total + advanced_tests_total))
  total_passed=$((basic_tests_passed + advanced_tests_passed))
  pass_percentage=$(( (total_passed * 100) / total_tests ))
  
  # Generate report
  ./generate_report.sh "../docs/test_reports/test_report_$(date +%Y%m%d_%H%M%S).md"
  
  echo -e "\n${YELLOW}Overall Test Summary: ${total_passed}/${total_tests} tests passed (${pass_percentage}%)${NC}"
}

# Main execution
case $TEST_TYPE in
  "basic")
    run_basic_tests
    ;;
  "advanced")
    run_advanced_tests
    ;;
  "all")
    run_basic_tests
    run_advanced_tests
    ;;
  *)
    echo "Invalid test type. Use 'basic', 'advanced', or 'all'"
    exit 1
    ;;
esac

# Generate the report
generate_report

# Exit with success if all tests passed
if [ $TEST_TYPE == "basic" ] && [ $basic_tests_passed -eq $basic_tests_total ]; then
  exit 0
elif [ $TEST_TYPE == "advanced" ] && [ $advanced_tests_passed -eq $advanced_tests_total ]; then
  exit 0
elif [ $TEST_TYPE == "all" ] && [ $total_passed -eq $total_tests ]; then
  exit 0
else
  exit 1
fi