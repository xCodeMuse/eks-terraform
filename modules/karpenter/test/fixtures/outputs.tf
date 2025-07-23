output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.test.name
}

output "iam_role_name" {
  description = "The name of the controller IAM role"
  value       = module.karpenter.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the controller IAM role"
  value       = module.karpenter.iam_role_arn
}

output "queue_name" {
  description = "The name of the created Amazon SQS queue"
  value       = module.karpenter.queue_name
}

output "queue_url" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.karpenter.queue_url
}

output "node_iam_role_name" {
  description = "The name of the node IAM role"
  value       = module.karpenter.node_iam_role_name
}

output "node_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the node IAM role"
  value       = module.karpenter.node_iam_role_arn
}

output "event_rules" {
  description = "Map of the event rules created and their attributes"
  value       = module.karpenter.event_rules
}