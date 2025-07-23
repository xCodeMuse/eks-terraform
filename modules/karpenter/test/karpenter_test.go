package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestKarpenterModule tests the Karpenter module
func TestKarpenterModule(t *testing.T) {
	t.Parallel()

	// Generate a random cluster name to prevent a naming conflict
	uniqueID := random.UniqueId()
	clusterName := fmt.Sprintf("terratest-karpenter-%s", uniqueID)

	// Get the AWS region
	awsRegion := aws.GetRandomStableRegion(t, []string{"us-west-2", "us-east-1", "eu-west-1"}, nil)

	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./fixtures",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"cluster_name": clusterName,
			"region":       awsRegion,
			"tags": map[string]string{
				"Environment": "test",
				"Terraform":   "true",
			},
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	iamRoleName := terraform.Output(t, terraformOptions, "iam_role_name")
	iamRoleArn := terraform.Output(t, terraformOptions, "iam_role_arn")
	queueName := terraform.Output(t, terraformOptions, "queue_name")
	queueUrl := terraform.Output(t, terraformOptions, "queue_url")

	// Verify that the IAM role was created with the expected name
	assert.Contains(t, iamRoleName, "KarpenterController")

	// Verify that the IAM role ARN is in the correct format
	assert.Contains(t, iamRoleArn, "arn:aws:iam::")
	assert.Contains(t, iamRoleArn, ":role/")

	// Verify that the SQS queue was created with the expected name
	assert.Contains(t, queueName, fmt.Sprintf("Karpenter-%s", clusterName))

	// Verify that the SQS queue URL is in the correct format
	assert.Contains(t, queueUrl, "https://sqs.")
	assert.Contains(t, queueUrl, ".amazonaws.com/")
}
