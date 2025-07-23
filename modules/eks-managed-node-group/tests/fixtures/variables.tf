# Variables for the fixtures

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "test-eks-cluster"
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
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

variable "create_launch_template" {
  description = "Determines whether to create a launch template or not"
  type        = bool
  default     = true
}

variable "use_custom_launch_template" {
  description = "Determines whether to use a custom launch template or not"
  type        = bool
  default     = true
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
  default     = {
    max_unavailable_percentage = 33
  }
}

variable "node_repair_config" {
  description = "The node auto repair configuration for the node group"
  type        = any
  default     = null
}

variable "metadata_options" {
  description = "Customize the metadata options for the instance"
  type        = map(string)
  default     = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "test"
    Terraform   = "true"
  }
}