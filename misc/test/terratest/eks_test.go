package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestEksClusterBasic tests the basic EKS cluster creation
func TestEksClusterBasic(t *testing.T) {
	t.Parallel()

	// Generate a random cluster name to prevent a naming conflict
	uniqueID := random.UniqueId()
	clusterName := fmt.Sprintf("terratest-eks-%s", uniqueID)

	// Get the AWS region
	awsRegion := aws.GetRandomStableRegion(t, []string{"us-west-2", "us-east-1", "eu-west-1"}, nil)

	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../fixtures/basic",

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
	clusterArn := terraform.Output(t, terraformOptions, "cluster_arn")
	clusterEndpoint := terraform.Output(t, terraformOptions, "cluster_endpoint")
	clusterName = terraform.Output(t, terraformOptions, "cluster_name")
	clusterSecurityGroupId := terraform.Output(t, terraformOptions, "cluster_security_group_id")
	oidcProviderArn := terraform.Output(t, terraformOptions, "oidc_provider_arn")

	// Verify that the outputs are not empty
	assert.NotEmpty(t, clusterArn)
	assert.NotEmpty(t, clusterEndpoint)
	assert.NotEmpty(t, clusterName)
	assert.NotEmpty(t, clusterSecurityGroupId)
	assert.NotEmpty(t, oidcProviderArn)

	// Verify that the cluster ARN is in the correct format
	assert.Contains(t, clusterArn, "arn:aws:eks:")
	assert.Contains(t, clusterArn, ":cluster/")

	// Verify that the cluster endpoint is in the correct format
	assert.Contains(t, clusterEndpoint, "https://")
	assert.Contains(t, clusterEndpoint, ".eks.")
	assert.Contains(t, clusterEndpoint, ".amazonaws.com")

	// Verify that the OIDC provider ARN is in the correct format
	assert.Contains(t, oidcProviderArn, "arn:aws:iam::")
	assert.Contains(t, oidcProviderArn, ":oidc-provider/")
}

// TestEksClusterWithNodeGroups tests the EKS cluster with managed node groups
func TestEksClusterWithNodeGroups(t *testing.T) {
	t.Parallel()

	// Generate a random cluster name to prevent a naming conflict
	uniqueID := random.UniqueId()
	clusterName := fmt.Sprintf("terratest-eks-%s", uniqueID)

	// Get the AWS region
	awsRegion := aws.GetRandomStableRegion(t, []string{"us-west-2", "us-east-1", "eu-west-1"}, nil)

	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../fixtures/node_groups",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"cluster_name":              clusterName,
			"region":                    awsRegion,
			"node_group_min_size":       1,
			"node_group_max_size":       3,
			"node_group_desired_size":   2,
			"node_group_instance_types": []string{"t3.medium"},
			"node_group_capacity_type":  "ON_DEMAND",
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
	clusterArn := terraform.Output(t, terraformOptions, "cluster_arn")
	clusterEndpoint := terraform.Output(t, terraformOptions, "cluster_endpoint")
	clusterName = terraform.Output(t, terraformOptions, "cluster_name")
	clusterSecurityGroupId := terraform.Output(t, terraformOptions, "cluster_security_group_id")
	oidcProviderArn := terraform.Output(t, terraformOptions, "oidc_provider_arn")
	nodeGroups := terraform.Output(t, terraformOptions, "eks_managed_node_groups")
	nodeGroupsAsgNames := terraform.Output(t, terraformOptions, "eks_managed_node_groups_autoscaling_group_names")

	// Verify that the outputs are not empty
	assert.NotEmpty(t, clusterArn)
	assert.NotEmpty(t, clusterEndpoint)
	assert.NotEmpty(t, clusterName)
	assert.NotEmpty(t, clusterSecurityGroupId)
	assert.NotEmpty(t, oidcProviderArn)
	assert.NotEmpty(t, nodeGroups)
	assert.NotEmpty(t, nodeGroupsAsgNames)

	// Verify that the cluster ARN is in the correct format
	assert.Contains(t, clusterArn, "arn:aws:eks:")
	assert.Contains(t, clusterArn, ":cluster/")

	// Verify that the cluster endpoint is in the correct format
	assert.Contains(t, clusterEndpoint, "https://")
	assert.Contains(t, clusterEndpoint, ".eks.")
	assert.Contains(t, clusterEndpoint, ".amazonaws.com")

	// Verify that the OIDC provider ARN is in the correct format
	assert.Contains(t, oidcProviderArn, "arn:aws:iam::")
	assert.Contains(t, oidcProviderArn, ":oidc-provider/")
}
