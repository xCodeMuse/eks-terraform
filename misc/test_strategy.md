# Terraform EKS Root Module Test Strategy Document

> **Purpose**: This document defines the testing approach, tools, scope, and procedures for validating the Terraform AWS EKS root module. It ensures changes are tested reliably before being deployed to production.

---

## 1. Overview

**Why:**  
The root module provisions a complete Amazon EKS cluster with supporting infrastructure. We want to ensure:
- The EKS cluster is created with the correct configuration
- All required resources are properly provisioned (IAM roles, security groups, KMS keys, etc.)
- Node groups (managed, self-managed, Fargate) can be attached correctly
- Outputs match expected values for downstream consumption
- The module works across multiple environments (dev, staging, prod)

---

## 2. Testing Framework

**Why:**  
We need to select appropriate testing tools based on the module's complexity and existing patterns.

**Recommendation:**  
Use a combination of:
- **Terraform Test Framework** (primary) - For declarative validation of configurations
- **Terratest** (secondary) - For more complex validation scenarios requiring programmatic testing

**Rationale:**
- Terraform Test Framework is already used in the eks-managed-node-group submodule
- Terratest is used in the karpenter submodule and provides more flexibility for complex tests
- This hybrid approach allows us to leverage the strengths of both frameworks

---

## 3. Module Under Test

**Path:** `/main.tf`, `/node_groups.tf`, `/variables.tf`, `/outputs.tf`, `/versions.tf`

---

## 4. Inputs

**Key Variables to Test:**
```hcl
cluster_name                    = "test-eks-cluster"
cluster_version                 = "1.28"
cluster_endpoint_private_access = true
cluster_endpoint_public_access  = true
vpc_id                          = "vpc-12345678"
subnet_ids                      = ["subnet-12345678", "subnet-87654321"]
enable_irsa                     = true
create_kms_key                  = true
```

---

## 5. Outputs

**Key Outputs to Verify:**
```hcl
cluster_arn
cluster_endpoint
cluster_id
cluster_name
cluster_certificate_authority_data
cluster_security_group_id
oidc_provider_arn
eks_managed_node_groups
self_managed_node_groups
fargate_profiles
```

---

## 6. Resources Under Test

**Primary Resources:**
- `aws_eks_cluster`
- `aws_iam_role` (cluster role)
- `aws_security_group` (cluster and node security groups)
- `aws_iam_openid_connect_provider`
- `aws_cloudwatch_log_group`
- `aws_eks_access_entry`
- `aws_eks_access_policy_association`
- `module.kms` (KMS key for encryption)

**Secondary Resources (via submodules):**
- `module.eks_managed_node_group`
- `module.self_managed_node_group`
- `module.fargate_profile`

---

## 7. Test Environment Setup

### Terraform Backend
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

### Authentication:
- Use AWS credentials via environment variables or AWS profile
- Test user must have permissions to create/destroy EKS clusters and related resources

### Fixtures:
- Directory: `test/fixtures/`
- Contains minimal reproducible test configurations

---

## 8. Sample Test Inputs

**Basic Cluster:**
```hcl
cluster_name    = "test-eks-cluster"
cluster_version = "1.28"
vpc_id          = "vpc-12345678"
subnet_ids      = ["subnet-12345678", "subnet-87654321"]
```

**Cluster with Node Groups:**
```hcl
cluster_name    = "test-eks-cluster"
cluster_version = "1.28"
vpc_id          = "vpc-12345678"
subnet_ids      = ["subnet-12345678", "subnet-87654321"]

eks_managed_node_groups = {
  default = {
    min_size     = 1
    max_size     = 3
    desired_size = 2
    instance_types = ["t3.medium"]
  }
}
```

---

## 9. Test Scenarios

| Scenario | Inputs | Expected Behavior |
|----------|--------|-------------------|
| Basic Cluster | `cluster_name`, `vpc_id`, `subnet_ids` | EKS cluster created with default settings |
| Private Cluster | `cluster_endpoint_private_access=true`, `cluster_endpoint_public_access=false` | Cluster with private endpoint only |
| Cluster with KMS Encryption | `create_kms_key=true`, `cluster_encryption_config` | Cluster with secrets encryption enabled |
| Cluster with IRSA | `enable_irsa=true` | OIDC provider created for IAM roles for service accounts |
| Cluster with Managed Node Group | `eks_managed_node_groups` config | Cluster with managed node group attached |
| Cluster with Self-Managed Node Group | `self_managed_node_groups` config | Cluster with self-managed node group attached |
| Cluster with Fargate Profile | `fargate_profiles` config | Cluster with Fargate profile attached |
| Cluster with Multiple Node Types | Multiple node group configs | Cluster with mixed node types |
| Invalid Configuration | `cluster_version="invalid"` | Terraform plan fails with validation error |

---

## 10. Test Implementation Approach

### 10.1 Terraform Test Framework (.tftest.hcl)

Create test files for different scenarios:
- `basic.tftest.hcl` - Test basic cluster creation
- `private.tftest.hcl` - Test private cluster configuration
- `encryption.tftest.hcl` - Test KMS encryption
- `node_groups.tftest.hcl` - Test with different node group configurations
- `fargate.tftest.hcl` - Test with Fargate profiles

Example test file structure:
```hcl
# basic.tftest.hcl
variables {
  cluster_name    = "test-eks-cluster"
  cluster_version = "1.28"
  vpc_id          = "vpc-12345678"
  subnet_ids      = ["subnet-12345678", "subnet-87654321"]
}

run "create_basic_cluster" {
  command = plan

  assert {
    condition     = length(var.subnet_ids) > 0
    error_message = "Subnet IDs must be provided"
  }
}
```

### 10.2 Terratest (Go)

Create Go test files for more complex scenarios:
- `eks_cluster_test.go` - Test full cluster deployment with validation

Example test structure:
```go
func TestEksCluster(t *testing.T) {
  t.Parallel()
  
  terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
    TerraformDir: "./fixtures",
    Vars: map[string]interface{}{
      "cluster_name": fmt.Sprintf("test-eks-%s", random.UniqueId()),
      "vpc_id": "vpc-12345678",
      "subnet_ids": []string{"subnet-12345678", "subnet-87654321"},
    },
  })
  
  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)
  
  clusterName := terraform.Output(t, terraformOptions, "cluster_name")
  assert.NotEmpty(t, clusterName)
}
```

---

## 11. Test Coverage and Gaps

**Tested:**
- Resource creation and configuration
- Input validation
- Output validation
- Integration with submodules

**Pending:**
- Performance testing
- Security compliance validation
- Multi-region deployment testing
- Upgrade path testing

---

## 12. CI Integration

Tests will be executed via GitHub Actions workflow:
- Run Terraform validation and format checks
- Run Terraform Test Framework tests
- Run Terratest tests for complex scenarios
- Generate test reports

---

## 13. Test Fixtures

Create the following test fixtures:
1. `test/fixtures/basic/` - Basic cluster configuration
2. `test/fixtures/node_groups/` - Cluster with node groups
3. `test/fixtures/fargate/` - Cluster with Fargate profiles
4. `test/fixtures/full/` - Complete cluster with all features

---

## 14. Conclusion & Next Steps

This test strategy provides a comprehensive approach to testing the EKS root module. The next steps are:

1. Implement the test fixtures
2. Create the Terraform test files
3. Develop Terratest files for complex scenarios
4. Set up CI pipeline for automated testing
5. Generate test reports