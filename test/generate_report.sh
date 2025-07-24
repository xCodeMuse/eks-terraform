#!/bin/bash

# Script to generate a test report from Terraform test results
# Usage: ./generate_report.sh [output_file]

# Default output file
OUTPUT_FILE=${1:-"../docs/test_reports/test_report_$(date +%Y%m%d_%H%M%S).md"}

# Get current date
DATE=$(date +"%Y-%m-%d")

# Get Terraform version
TF_VERSION=$(terraform version -json | jq -r '.terraform_version')

# Get AWS provider version
AWS_PROVIDER_VERSION=$(terraform version -json | jq -r '.provider_selections."registry.terraform.io/hashicorp/aws"')

# Get current AWS region
AWS_REGION=$(aws configure get region)

# Get AWS account ID (last 4 digits only)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
AWS_ACCOUNT_ID_LAST4=${AWS_ACCOUNT_ID: -4}

# Create a copy of the template
cp ../docs/test_reports/test_report_template.md "$OUTPUT_FILE"

# Replace placeholders in the template
sed -i "s/\[DATE\]/$DATE/g" "$OUTPUT_FILE"
sed -i "s/\[TERRAFORM VERSION\]/$TF_VERSION/g" "$OUTPUT_FILE"
sed -i "s/\[AWS PROVIDER VERSION\]/$AWS_PROVIDER_VERSION/g" "$OUTPUT_FILE"
sed -i "s/\[REGION\]/$AWS_REGION/g" "$OUTPUT_FILE"
sed -i "s/\[ACCOUNT ID\]/$AWS_ACCOUNT_ID_LAST4/g" "$OUTPUT_FILE"

echo "Test report template generated: $OUTPUT_FILE"
echo "Please fill in the test results manually."
echo ""
echo "To run all tests and update the report:"
echo "1. Run 'make test-all-basic' and 'make test-all-advanced'"
echo "2. Update the test results in $OUTPUT_FILE"
echo ""
echo "Remember to include:"
echo "- VPC ID and Subnet IDs used for testing"
echo "- Test results (pass/fail) for each test case"
echo "- Any issues found during testing"
echo "- Recommendations for improvements"
echo "- Test duration and performance metrics"
echo "- Test coverage percentages"
echo "- Relevant test logs in the appendix"