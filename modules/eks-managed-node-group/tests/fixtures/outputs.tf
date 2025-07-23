# Outputs from the fixtures

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.test.name
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.test.endpoint
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.test.id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = [aws_subnet.test1.id, aws_subnet.test2.id]
}

# Outputs from the EKS Managed Node Group module
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

output "node_group_resources" {
  description = "List of objects containing information about underlying resources"
  value       = module.eks_managed_node_group.node_group_resources
}

output "node_group_autoscaling_group_names" {
  description = "List of the autoscaling group names"
  value       = module.eks_managed_node_group.node_group_autoscaling_group_names
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.eks_managed_node_group.launch_template_id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.eks_managed_node_group.launch_template_arn
}

output "launch_template_name" {
  description = "The name of the launch template"
  value       = module.eks_managed_node_group.launch_template_name
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.eks_managed_node_group.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.eks_managed_node_group.iam_role_arn
}