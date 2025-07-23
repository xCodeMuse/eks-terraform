# Mock resources for testing EKS Managed Node Group module

# Mock AWS provider with skip options to avoid real AWS calls
provider "aws" {
  region                      = "us-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock-access-key"
  secret_key                  = "mock-secret-key"
}

# Variables for the module
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "test-eks-cluster"
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]
}

variable "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  type        = string
  default     = "https://test-eks-cluster.eks.amazonaws.com"
}

variable "cluster_auth_base64" {
  description = "Base64 encoded certificate authority data for the EKS cluster"
  type        = string
  default     = "dGVzdC1jbHVzdGVyLWF1dGg="
}

variable "cluster_service_cidr" {
  description = "The CIDR block used by the cluster to assign Kubernetes service IP addresses"
  type        = string
  default     = "172.20.0.0/16"
}

variable "name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "test-node-group"
}

variable "min_size" {
  description = "Minimum number of instances/nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances/nodes"
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of instances/nodes"
  type        = number
  default     = 2
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = "AL2_x86_64"
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  type        = string
  default     = "ON_DEMAND"
}

variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "labels" {
  description = "Key-value map of Kubernetes labels"
  type        = map(string)
  default     = null
}

variable "taints" {
  description = "The Kubernetes taints to be applied to the nodes in the node group"
  type        = any
  default     = {}
}

variable "update_config" {
  description = "Configuration block of settings for max unavailable resources during node group updates"
  type        = map(string)
  default     = null
}

variable "node_repair_config" {
  description = "The node auto repair configuration for the node group"
  type        = any
  default     = null
}

variable "metadata_options" {
  description = "Customize the metadata options for the instance"
  type        = map(string)
  default     = null
}

variable "create_schedule" {
  description = "Determines whether to create autoscaling group schedule or not"
  type        = bool
  default     = false
}

variable "schedules" {
  description = "Map of autoscaling group schedule to create"
  type        = map(any)
  default     = {}
}

variable "pre_bootstrap_user_data" {
  description = "User data that is injected into the user data script ahead of the EKS bootstrap script"
  type        = string
  default     = ""
}

variable "post_bootstrap_user_data" {
  description = "User data that is appended to the user data script after of the EKS bootstrap script"
  type        = string
  default     = ""
}

variable "bootstrap_extra_args" {
  description = "Additional arguments passed to the bootstrap script"
  type        = string
  default     = ""
}

variable "create_launch_template" {
  description = "Determines whether to create a launch template or not"
  type        = bool
  default     = true
}

variable "use_custom_launch_template" {
  description = "Determines whether to use a custom launch template or not"
  type        = bool
  default     = false
}

variable "launch_template_name" {
  description = "Name of launch template to be created"
  type        = string
  default     = null
}

variable "launch_template_use_name_prefix" {
  description = "Determines whether to use `launch_template_name` as is or create a unique name beginning with the `launch_template_name` as the prefix"
  type        = bool
  default     = true
}

variable "launch_template_description" {
  description = "Description of the launch template"
  type        = string
  default     = null
}

variable "create_iam_role" {
  description = "Determines whether an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "test"
    Terraform   = "true"
  }
}

# Mock VPC
resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "test-vpc"
  }
}

# Mock Subnets
resource "aws_subnet" "test1" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  
  tags = {
    Name = "test-subnet-1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "test2" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  
  tags = {
    Name = "test-subnet-2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Mock IAM Role for EKS Cluster
resource "aws_iam_role" "cluster" {
  name = "test-eks-cluster-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Mock Security Group
resource "aws_security_group" "test" {
  name        = "test-sg"
  description = "Test security group"
  vpc_id      = aws_vpc.test.id
}

# Mock EKS Cluster
resource "aws_eks_cluster" "test" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  
  vpc_config {
    subnet_ids = [aws_subnet.test1.id, aws_subnet.test2.id]
  }
}

# Mock data sources for the EKS cluster
data "aws_eks_cluster" "test" {
  name = aws_eks_cluster.test.name
}

data "aws_eks_cluster_auth" "test" {
  name = aws_eks_cluster.test.name
}

# Use the EKS Managed Node Group module
module "eks_managed_node_group" {
  source = "./.."
  
  cluster_name    = aws_eks_cluster.test.name
  cluster_version = "1.28"
  
  # Use mock values
  cluster_endpoint     = var.cluster_endpoint
  cluster_auth_base64  = var.cluster_auth_base64
  cluster_service_cidr = var.cluster_service_cidr
  
  subnet_ids = [aws_subnet.test1.id, aws_subnet.test2.id]
  
  # Node group configuration
  name         = var.name
  min_size     = var.min_size
  max_size     = var.max_size
  desired_size = var.desired_size
  
  # Instance configuration
  ami_type        = var.ami_type
  capacity_type   = var.capacity_type
  instance_types  = var.instance_types
  
  # Launch template configuration
  create_launch_template          = var.create_launch_template
  use_custom_launch_template      = var.use_custom_launch_template
  launch_template_name            = var.launch_template_name
  launch_template_use_name_prefix = var.launch_template_use_name_prefix
  launch_template_description     = var.launch_template_description
  
  # IAM configuration
  create_iam_role            = var.create_iam_role
  iam_role_name              = var.iam_role_name
  iam_role_use_name_prefix   = var.iam_role_use_name_prefix
  iam_role_description       = var.iam_role_description
  iam_role_additional_policies = var.iam_role_additional_policies
  
  # User data configuration
  pre_bootstrap_user_data  = var.pre_bootstrap_user_data
  post_bootstrap_user_data = var.post_bootstrap_user_data
  bootstrap_extra_args     = var.bootstrap_extra_args
  
  # Other configurations
  labels                = var.labels
  taints                = var.taints
  update_config         = var.update_config
  node_repair_config    = var.node_repair_config
  metadata_options      = var.metadata_options
  create_schedule       = var.create_schedule
  schedules             = var.schedules
  
  tags = var.tags
}

# Outputs
output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = module.eks_managed_node_group.node_group_arn
}

output "node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
  value       = module.eks_managed_node_group.node_group_id
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = module.eks_managed_node_group.node_group_status
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.eks_managed_node_group.launch_template_id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.eks_managed_node_group.launch_template_arn
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.eks_managed_node_group.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.eks_managed_node_group.iam_role_arn
}