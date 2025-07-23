# Mock resources for testing

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

# Mock EKS Cluster
resource "aws_eks_cluster" "test" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  
  vpc_config {
    subnet_ids = [aws_subnet.test1.id, aws_subnet.test2.id]
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

# Use the EKS Managed Node Group module
module "eks_managed_node_group" {
  source = "../.."
  
  cluster_name    = aws_eks_cluster.test.name
  cluster_version = "1.28"
  
  # Use mock values from the test file
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