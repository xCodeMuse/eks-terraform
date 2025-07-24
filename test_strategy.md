# Terraform AWS EKS Module Test Strategy Document

## 1. Overview

This document defines the testing approach, tools, scope, and procedures for validating the Terraform AWS EKS root module and its integrated submodules. It ensures changes are tested reliably before being deployed to production environments.

The AWS EKS module is a comprehensive solution for creating and managing Elastic Kubernetes Service clusters on AWS. It includes the main cluster configuration along with several integrated submodules for node management, including:

- Fargate Profiles
- EKS Managed Node Groups
- Self-Managed Node Groups
- Karpenter (for autoscaling)

This test strategy aims to validate both the individual functionality of each component and their integration as a complete system. It includes both unit tests and functional tests to provide comprehensive validation of the module.

## 2. Testing Framework

### Primary Testing Tools

1. **Terraform Native Testing (tftest)** - For both unit testing (plan) and functional testing (apply) of module configurations and outputs
2. **Terratest (Go)** - For comprehensive end-to-end functional testing of the deployed infrastructure
3. **AWS CLI** - For validating the actual resources created in AWS during functional tests

### Test Types

#### Unit Tests
Unit tests validate the module configuration without creating actual AWS resources:
- Use the `plan` command instead of `apply`
- Mock the AWS provider
- Validate configuration syntax and structure
- Check resource definitions, inputs, and outputs
- Run quickly and don't incur AWS costs

#### Functional Tests
Functional tests create actual AWS resources and validate their behavior:
- Use the `apply` command to create resources
- Validate that resources are created correctly
- Test interactions between components
- Verify real-world behavior
- Incur AWS costs and take longer to run

### Rationale for Tool Selection

- **Terraform Native Testing**:
  - For unit tests: Provides fast, lightweight validation of module configurations without requiring actual resource creation
  - For functional tests: Enables validation of actual resource creation and configuration

- **Terratest**: Enables comprehensive functional testing of the actual deployed resources and their behavior

- **AWS CLI**: Allows direct verification of resources and their configurations in AWS during functional testing

## 3. Module Under Test

**Path**: Root module (`.`)

**Submodules**:
- `./modules/fargate-profile`
- `./modules/eks-managed-node-group`
- `./modules/self-managed-node-group`
- `./modules/karpenter`
- `./modules/aws-auth`
- `./modules/_user_data`
- `./modules/hybrid-node-role`

## 4. Inputs

The module has numerous configurable variables. Key variables to test include:

| Variable | Description | Test Considerations |
|----------|-------------|---------------------|
| `cluster_name` | Name of the EKS cluster | Test with various naming patterns |
| `cluster_version` | Kubernetes version | Test with different versions to ensure compatibility |
| `subnet_ids` | Subnet IDs for node groups | Test with different subnet configurations |
| `vpc_id` | VPC ID | Test with different VPC configurations |
| `cluster_endpoint_private_access` | Enable private API endpoint | Test both true/false configurations |
| `cluster_endpoint_public_access` | Enable public API endpoint | Test both true/false configurations |
| `cluster_addons` | EKS add-ons to enable | Test with various combinations of add-ons |
| `eks_managed_node_groups` | Configuration for managed node groups | Test various configurations |
| `self_managed_node_groups` | Configuration for self-managed node groups | Test various configurations |
| `fargate_profiles` | Configuration for Fargate profiles | Test various configurations |
| `authentication_mode` | Authentication mode for the cluster | Test different authentication modes |
| `cluster_ip_family` | IP family (IPv4/IPv6) | Test both IPv4 and IPv6 configurations |
| `enable_irsa` | Enable IAM Roles for Service Accounts | Test both true/false configurations |

## 5. Outputs

Key outputs to verify include:

| Output | Description | Validation Approach |
|--------|-------------|---------------------|
| `cluster_arn` | ARN of the cluster | Verify format and existence |
| `cluster_endpoint` | Endpoint for Kubernetes API server | Verify accessibility and format |
| `cluster_certificate_authority_data` | Certificate data for cluster | Verify presence and format |
| `cluster_name` | Name of the EKS cluster | Verify matches input |
| `cluster_oidc_issuer_url` | OIDC issuer URL | Verify format and functionality |
| `cluster_version` | Kubernetes version | Verify matches input |
| `cluster_status` | Status of the EKS cluster | Verify is "ACTIVE" after creation |
| `eks_managed_node_groups` | Map of EKS managed node groups | Verify structure and properties |
| `self_managed_node_groups` | Map of self-managed node groups | Verify structure and properties |
| `fargate_profiles` | Map of Fargate profiles | Verify structure and properties |

## 6. Resources Under Test

Key resources to validate:

1. **EKS Cluster**
   - Proper configuration
   - Correct version
   - Proper networking setup
   - Security group configuration

2. **IAM Roles and Policies**
   - Cluster role
   - Node group roles
   - IRSA configuration

3. **Node Groups**
   - EKS Managed Node Groups
   - Self-Managed Node Groups
   - Launch templates
   - Autoscaling groups

4. **Networking**
   - VPC configuration
   - Subnet configuration
   - Security group rules

5. **Add-ons**
   - CoreDNS
   - kube-proxy
   - VPC CNI
   - Custom add-ons

6. **Authentication**
   - Access entries
   - aws-auth ConfigMap (if used)

## 7. Test Environment Setup

### Prerequisites

1. **AWS Account**
   - Sufficient permissions to create EKS clusters and related resources
   - Sufficient service quotas for EKS, EC2, VPC, etc.

2. **Terraform Environment**
   - Terraform CLI (version >= 1.3.2)
   - AWS provider (version >= 5.95, < 6.0.0)
   - TLS provider (version >= 3.0)
   - Time provider (version >= 0.9)

3. **Testing Tools**
   - Go (for Terratest)
   - AWS CLI

### Test VPC Setup

Create a dedicated VPC for testing with:
- At least 2 public and 2 private subnets across different AZs
- NAT Gateway for private subnet internet access
- Proper route tables and security groups

### Test Isolation

- Use unique naming prefixes for all resources
- Create resources in a dedicated AWS region/account for testing
- Implement proper cleanup procedures after tests

## 8. Sample Test Inputs

### Basic Cluster Configuration

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "test-eks-cluster"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }

  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}
```

### Advanced Configuration

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "test-eks-advanced"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 5
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
        }
      ]
    }
  }

  # Self Managed Node Group(s)
  self_managed_node_groups = {
    spot = {
      instance_type = "m5.large"
      instance_market_options = {
        market_type = "spot"
      }
    }

    min_size     = 1
    max_size     = 3
    desired_size = 1
  }

  # Enable IRSA
  enable_irsa = true

  # EKS Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}
```

## 9. Test Scenarios

### Unit Tests

1. **Module Configuration**
   - Validate the basic module structure and dependencies
   - Verify resource definitions are correct
   - Check that variables are properly defined and validated
   - Ensure outputs are correctly defined

2. **Cluster Configuration**
   - Verify the EKS cluster configuration parameters
   - Check cluster version is set correctly
   - Validate cluster endpoint configuration
   - Verify cluster IAM role configuration

3. **Node Group Configuration**
   - Check EKS managed node group configurations
   - Verify node group IAM roles
   - Validate node group launch templates
   - Check node group scaling configuration

4. **Fargate Profile Configuration**
   - Validate Fargate profile configurations
   - Check namespace and label selectors
   - Verify Fargate profile IAM role

5. **Add-on Configuration**
   - Verify EKS add-on configurations
   - Check add-on versions
   - Validate add-on configuration parameters

6. **Security Group Configuration**
   - Check security group configurations
   - Verify security group rules
   - Validate security group associations

7. **IAM Role Configuration**
   - Validate IAM role configurations
   - Check IAM policies
   - Verify trust relationships

### Functional Tests

#### Basic Functionality Tests

1. **Cluster Creation**
   - Create a basic EKS cluster with default settings
   - Verify cluster is created successfully
   - Verify cluster endpoint is accessible
   - Verify kubectl can connect to the cluster

2. **Node Group Management**
   - Create EKS managed node groups
   - Verify nodes join the cluster
   - Verify node labels and taints
   - Test scaling operations (up and down)

3. **Fargate Profile**
   - Create Fargate profiles
   - Deploy pods matching Fargate selectors
   - Verify pods run on Fargate

4. **Add-on Management**
   - Install and configure EKS add-ons
   - Verify add-ons are running correctly
   - Test upgrading add-ons

### Integration Tests

1. **Mixed Node Types**
   - Create a cluster with both managed and self-managed node groups
   - Create a cluster with both EC2 nodes and Fargate
   - Verify workload scheduling across different node types

2. **Networking Integration**
   - Test pod networking across node groups
   - Test service connectivity
   - Test ingress/load balancer integration

3. **IAM Integration**
   - Test IRSA functionality
   - Test pod identity with service accounts
   - Verify proper IAM role assumption

### Advanced Tests

1. **HIPAA Compliance Tests**
    - Verify encryption at rest (etcd) using KMS
    - Verify encryption in transit (TLS) for all communication
    - Verify access control by testing IAM role creation
    - Verify data disposal (KMS key deletion window)
    - Verify access logging (CloudWatch log group existence)

2. **Upgrade Scenarios**
   - Test upgrading the Kubernetes version
   - Test upgrading node groups
   - Test upgrading add-ons

3. **Failure Recovery**
   - Test node failure recovery
   - Test control plane failure recovery
   - Test network partition scenarios

4. **Security Tests**
   - Verify security group configurations
   - Test network policy enforcement
   - Verify encryption configurations

## 10. Test Coverage and Gaps

### HIPAA Compliance Coverage

- Encryption at rest (etcd) using KMS
- Encryption in transit (TLS) for all communication
- Access control by testing IAM role creation
- Access logging (CloudWatch log group existence)

### Coverage Areas

- Cluster creation and configuration
- Node group management
- IAM role and policy configuration
- Security group configuration
- Add-on management
- Basic networking functionality

### Known Gaps

- Performance testing under load
- Long-term stability testing
- Multi-region/multi-account scenarios
- Disaster recovery scenarios
- Custom networking configurations (e.g., custom CNI)

## 11. CI Integration

### Test Automation

1. **Pull Request Validation**
   - Run basic validation tests on every PR
   - Verify module syntax and structure
   - Run terraform plan to catch potential issues

2. **Nightly Tests**
   - Run full end-to-end tests nightly
   - Create and destroy complete EKS clusters
   - Test various configurations

3. **Release Validation**
   - Run comprehensive test suite before releases
   - Test upgrade paths from previous versions
   - Validate all examples

### GitHub Actions Workflow

A GitHub Actions workflow has been configured to automate testing:

1. **Validation Job**
   - Runs on all PRs and pushes to main
   - Checks Terraform formatting
   - Validates Terraform syntax
   - Ensures the module can be initialized

2. **Plan-Only Tests**
   - Runs on all PRs and pushes to main
   - Executes basic tests in plan mode only
   - Verifies configurations without creating resources

3. **Basic Tests**
   - Runs only on pushes to main
   - Executes all basic tests
   - Creates actual AWS resources
   - Generates and uploads test reports

4. **Advanced Tests**
   - Runs only on pushes to main
   - Executes all advanced tests
   - Creates actual AWS resources
   - Generates and uploads test reports

5. **Cleanup**
   - Runs after all tests complete
   - Destroys all created resources
   - Ensures no resources are left running

### Test Reporting

- Generate detailed test reports using the provided templates
- Upload test reports as artifacts in GitHub Actions
- Track test coverage over time
- Document known issues and workarounds

## 12. Conclusion & Next Steps

This test strategy provides a comprehensive approach to testing the AWS EKS Terraform module and its integrated submodules. By following this strategy, we can ensure the module functions correctly across various configurations and scenarios.

### Next Steps

1. Implement basic test fixtures for the main module
2. Develop Terratest scripts for end-to-end testing
3. Set up CI/CD pipeline for automated testing
4. Create detailed test cases based on the scenarios outlined in this document

## Appendix A: Test Case Template

# AWS Configuration

# Terraform Variables