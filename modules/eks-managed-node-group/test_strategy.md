### Infrastructure Test Strategy Template

**1. Testing Framework**
- Recommendation: [`Terraform Test Framework`](https://developer.hashicorp.com/terraform/language/tests) (built-in) instead of Terratest.

**2. Module Under Test**
- Path: `modules/eks-managed-node-group/main.tf`

**3. Inputs**
- `create` [`variable.create()`](variables.tf:1): Determines whether to create EKS managed node group or not.
- `tags` [`variable.tags()`](variables.tf:7): A map of tags to add to all resources.
- `platform` [`variable.platform()`](variables.tf:13): [DEPRECATED] Identifies the OS platform.
- `enable_bootstrap_user_data` [`variable.enable_bootstrap_user_data()`](variables.tf:23): Determines whether the bootstrap configurations are populated within the user data template.
- `cluster_name` [`variable.cluster_name()`](variables.tf:29): Name of associated EKS cluster.
- `cluster_endpoint` [`variable.cluster_endpoint()`](variables.tf:35): Endpoint of associated EKS cluster.
- `cluster_auth_base64` [`variable.cluster_auth_base64()`](variables.tf:41): Base64 encoded CA of associated EKS cluster.
- `cluster_service_cidr` [`variable.cluster_service_cidr()`](variables.tf:47): The CIDR block used by the cluster to assign Kubernetes service IP addresses.
- `pre_bootstrap_user_data` [`variable.pre_bootstrap_user_data()`](variables.tf:60): User data that is injected into the user data script ahead of the EKS bootstrap script.
- `post_bootstrap_user_data` [`variable.post_bootstrap_user_data()`](variables.tf:66): User data that is appended to the user data script after of the EKS bootstrap script.
- `bootstrap_extra_args` [`variable.bootstrap_extra_args()`](variables.tf:72): Additional arguments passed to the bootstrap script.
- `user_data_template_path` [`variable.user_data_template_path()`](variables.tf:78): Path to a local, custom user data template file to use when rendering user data.
- `cloudinit_pre_nodeadm` [`variable.cloudinit_pre_nodeadm()`](variables.tf:84): Array of cloud-init document parts that are created before the nodeadm document part.
- `cloudinit_post_nodeadm` [`variable.cloudinit_post_nodeadm()`](variables.tf:95): Array of cloud-init document parts that are created after the nodeadm document part.
- `create_launch_template` [`variable.create_launch_template()`](variables.tf:110): Determines whether to create a launch template or not.
- `use_custom_launch_template` [`variable.use_custom_launch_template()`](variables.tf:116): Determines whether to use a custom launch template or not.
- `launch_template_id` [`variable.launch_template_id()`](variables.tf:122): The ID of an existing launch template to use.
- `launch_template_name` [`variable.launch_template_name()`](variables.tf:128): Name of launch template to be created.
- `launch_template_use_name_prefix` [`variable.launch_template_use_name_prefix()`](variables.tf:134): Determines whether to use `launch_template_name` as is or create a unique name.
- `launch_template_description` [`variable.launch_template_description()`](variables.tf:140): Description of the launch template.
- `ebs_optimized` [`variable.ebs_optimized()`](variables.tf:146): If true, the launched EC2 instance(s) will be EBS-optimized.
- `ami_id` [`variable.ami_id()`](variables.tf:152): The AMI from which to launch the instance.
- `key_name` [`variable.key_name()`](variables.tf:158): The key name that should be used for the instance(s).
- `vpc_security_group_ids` [`variable.vpc_security_group_ids()`](variables.tf:164): A list of security group IDs to associate.
- `cluster_primary_security_group_id` [`variable.cluster_primary_security_group_id()`](variables.tf:170): The ID of the EKS cluster primary security group.
- `subnet_ids` [`variable.subnet_ids()`](variables.tf:349): Identifiers of EC2 Subnets to associate with the EKS Node Group.
- `min_size` [`variable.min_size()`](variables.tf:361): Minimum number of instances/nodes.
- `max_size` [`variable.max_size()`](variables.tf:367): Maximum number of instances/nodes.
- `desired_size` [`variable.desired_size()`](variables.tf:373): Desired number of instances/nodes.
- `name` [`variable.name()`](variables.tf:379): Name of the EKS managed node group.
- `ami_type` [`variable.ami_type()`](variables.tf:391): Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
- `capacity_type` [`variable.capacity_type()`](variables.tf:409): Type of capacity associated with the EKS Node Group.
- `disk_size` [`variable.disk_size()`](variables.tf:415): Disk size in GiB for nodes.
- `force_update_version` [`variable.force_update_version()`](variables.tf:421): Force version update if existing pods are unable to be drained.
- `instance_types` [`variable.instance_types()`](variables.tf:427): Set of instance types associated with the EKS Node Group.
- `labels` [`variable.labels()`](variables.tf:433): Key-value map of Kubernetes labels.
- `taints` [`variable.taints()`](variables.tf:457): The Kubernetes taints to be applied to the nodes in the node group.
- `update_config` [`variable.update_config()`](variables.tf:463): Configuration block of settings for max unavailable resources during node group updates.
- `create_iam_role` [`variable.create_iam_role()`](variables.tf:489): Determines whether an IAM role is created or to use an existing IAM role.
- `cluster_ip_family` [`variable.cluster_ip_family()`](variables.tf:495): The IP family used to assign Kubernetes pod and service addresses.
- `iam_role_arn` [`variable.iam_role_arn()`](variables.tf:501): Existing IAM role ARN for the node group.
- `iam_role_name` [`variable.iam_role_name()`](variables.tf:507): Name to use on IAM role created.
- `iam_role_use_name_prefix` [`variable.iam_role_use_name_prefix()`](variables.tf:513): Determines whether the IAM role name is used as a prefix.
- `iam_role_path` [`variable.iam_role_path()`](variables.tf:519): IAM role path.
- `iam_role_description` [`variable.iam_role_description()`](variables.tf:525): Description of the role.
- `iam_role_permissions_boundary` [`variable.iam_role_permissions_boundary()`](variables.tf:531): ARN of the policy that is used to set the permissions boundary for the IAM role.
- `iam_role_attach_cni_policy` [`variable.iam_role_attach_cni_policy()`](variables.tf:537): Whether to attach the CNI IAM policy to the IAM role.
- `iam_role_additional_policies` [`variable.iam_role_additional_policies()`](variables.tf:543): Additional policies to be added to the IAM role.
- `create_iam_role_policy` [`variable.create_iam_role_policy()`](variables.tf:559): Determines whether an IAM role policy is created or not.
- `iam_role_policy_statements` [`variable.iam_role_policy_statements()`](variables.tf:565): A list of IAM policy statements.
- `create_schedule` [`variable.create_schedule()`](variables.tf:575): Determines whether to create autoscaling group schedule or not.
- `schedules` [`variable.schedules()`](variables.tf:581): Map of autoscaling group schedule to create.

**4. Outputs**
- `launch_template_id` [`output.launch_template_id()`](outputs.tf:5): The ID of the launch template.
- `launch_template_arn` [`output.launch_template_arn()`](outputs.tf:10): The ARN of the launch template.
- `launch_template_latest_version` [`output.launch_template_latest_version()`](outputs.tf:15): The latest version of the launch template.
- `launch_template_name` [`output.launch_template_name()`](outputs.tf:20): The name of the launch template.
- `node_group_arn` [`output.node_group_arn()`](outputs.tf:29): Amazon Resource Name (ARN) of the EKS Node Group.
- `node_group_id` [`output.node_group_id()`](outputs.tf:34): EKS Cluster name and EKS Node Group name separated by a colon.
- `node_group_resources` [`output.node_group_resources()`](outputs.tf:39): List of objects containing information about underlying resources.
- `node_group_autoscaling_group_names` [`output.node_group_autoscaling_group_names()`](outputs.tf:44): List of the autoscaling group names.
- `node_group_status` [`output.node_group_status()`](outputs.tf:49): Status of the EKS Node Group.
- `node_group_labels` [`output.node_group_labels()`](outputs.tf:54): Map of labels applied to the node group.
- `node_group_taints` [`output.node_group_taints()`](outputs.tf:59): List of objects containing information about taints applied to the node group.
- `autoscaling_group_schedule_arns` [`output.autoscaling_group_schedule_arns()`](outputs.tf:68): ARNs of autoscaling group schedules.
- `iam_role_name` [`output.iam_role_name()`](outputs.tf:77): The name of the IAM role.
- `iam_role_arn` [`output.iam_role_arn()`](outputs.tf:82): The Amazon Resource Name (ARN) specifying the IAM role.
- `iam_role_unique_id` [`output.iam_role_unique_id()`](outputs.tf:87): Stable and unique string identifying the IAM role.
- `platform` [`output.platform()`](outputs.tf:96): [DEPRECATED] Identifies the OS platform.

**5. Resources Managed**
- [`module.user_data`](main.tf:8): User data module for node bootstrap.
- [`aws_launch_template.this`](main.tf:72): Launch template for the EKS node group.
- [`aws_eks_node_group.this`](main.tf:395): EKS managed node group.
- [`aws_iam_role.this`](main.tf:521): IAM role for the EKS node group.
- [`aws_iam_role_policy_attachment.this`](main.tf:537): IAM role policy attachments for the EKS node group.
- [`aws_iam_role_policy_attachment.additional`](main.tf:551): Additional IAM role policy attachments.
- [`aws_iam_role_policy.this`](main.tf:611): IAM role policy for the EKS node group.
- [`aws_placement_group.this`](main.tf:628): Placement group for the EKS node group.
- [`aws_autoscaling_schedule.this`](main.tf:695): Autoscaling schedules for the EKS node group.

**6. Test Environment Setup**
- Backend: local
- Credentials: `AWS_PROFILE`
- Fixtures: Separate directory named `tests` inside the `modules/eks-managed-node-group` directory.

**7. Sample Test Inputs**
```hcl
cluster_name = "test-eks-cluster"
subnet_ids   = ["subnet-12345678", "subnet-87654321"]
tags = {
  Environment = "test"
}
```

**8. Terraform Test Framework Approach**
- Use Terraform's built-in test framework introduced in Terraform 1.6+
- Create test files with `.tftest.hcl` extension
- Define test cases that validate the module's functionality
- Use assertions to verify expected outputs and resource attributes