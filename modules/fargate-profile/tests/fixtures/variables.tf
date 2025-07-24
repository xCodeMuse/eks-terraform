# Variables for the fixtures

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "test-eks-cluster"
}

variable "name" {
  description = "Name of the EKS Fargate Profile"
  type        = string
  default     = "test-fargate-profile"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "test"
    Terraform   = "true"
  }
}

variable "selectors" {
  description = "Configuration block(s) for selecting Kubernetes Pods to execute with this Fargate Profile"
  type        = any
  default     = [
    {
      namespace = "kube-system"
    },
    {
      namespace = "default"
      labels = {
        workload-type = "fargate"
      }
    }
  ]
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS Fargate Profile"
  type        = list(string)
  default     = []
}

# IAM Role variables
variable "create_iam_role" {
  description = "Determines whether an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "cluster_ip_family" {
  description = "The IP family used to assign Kubernetes pod and service addresses. Valid values are `ipv4` (default) and `ipv6`"
  type        = string
  default     = "ipv4"
}

variable "iam_role_arn" {
  description = "Existing IAM role ARN for the Fargate profile. Required if `create_iam_role` is set to `false`"
  type        = string
  default     = null
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = ""
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_attach_cni_policy" {
  description = "Whether to attach the `AmazonEKS_CNI_Policy`/`AmazonEKS_CNI_IPv6_Policy` IAM policy to the IAM IAM role"
  type        = bool
  default     = true
}

variable "iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = map(string)
  default     = {}
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

# IAM Role Policy variables
variable "create_iam_role_policy" {
  description = "Determines whether an IAM role policy is created or not"
  type        = bool
  default     = false
}

variable "iam_role_policy_statements" {
  description = "A list of IAM policy statements"
  type        = any
  default     = []
}

# Timeouts
variable "timeouts" {
  description = "Create and delete timeout configurations for the Fargate Profile"
  type        = map(string)
  default     = {}
}