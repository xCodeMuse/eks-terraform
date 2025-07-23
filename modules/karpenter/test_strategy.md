### Infrastructure Test Strategy Template

**1. Testing Framework**
- Recommendation: [`Terratest`](https://terratest.gruntwork.io/) (Go) or alternatives like [`kitchen-terraform`](https://newcontext-oss.github.io/kitchen-terraform/), based on your setup.

**2. Module Under Test**
- Path: `modules/karpenter/main.tf`

**3. Inputs**
- `create` [`variable.create()`](variables.tf:1): Controls if resources should be created (affects nearly all resources).
- `tags` [`variable.tags()`](variables.tf:7): A map of tags to add to all resources.
- `cluster_name` [`variable.cluster_name()`](variables.tf:13): The name of the EKS cluster.
- `create_iam_role` [`variable.create_iam_role()`](variables.tf:23): Determines whether an IAM role is created.
- `iam_role_name` [`variable.iam_role_name()`](variables.tf:29): Name of the IAM role.
- `iam_role_use_name_prefix` [`variable.iam_role_use_name_prefix()`](variables.tf:35): Determines whether the name of the IAM role (`iam_role_name`) is used as a prefix.
- `iam_role_path` [`variable.iam_role_path()`](variables.tf:41): Path of the IAM role.
- `iam_role_description` [`variable.iam_role_description()`](variables.tf:47): IAM role description.
- `iam_role_max_session_duration` [`variable.iam_role_max_session_duration()`](variables.tf:53): Maximum API session duration in seconds between 3600 and 43200.
- `iam_role_permissions_boundary_arn` [`variable.iam_role_permissions_boundary_arn()`](variables.tf:59): Permissions boundary ARN to use for the IAM role.
- `iam_role_tags` [`variable.iam_role_tags()`](variables.tf:65): A map of additional tags to add the the IAM role.
- `iam_policy_name` [`variable.iam_policy_name()`](variables.tf:71): Name of the IAM policy.
- `iam_policy_use_name_prefix` [`variable.iam_policy_use_name_prefix()`](variables.tf:77): Determines whether the name of the IAM policy (`iam_policy_name`) is used as a prefix.
- `iam_policy_path` [`variable.iam_policy_path()`](variables.tf:83): Path of the IAM policy.
- `iam_policy_description` [`variable.iam_policy_description()`](variables.tf:89): IAM policy description.
- `iam_policy_statements` [`variable.iam_policy_statements()`](variables.tf:95): A list of IAM policy statements - used for adding specific IAM permissions as needed.
- `iam_role_policies` [`variable.iam_role_policies()`](variables.tf:101): Policies to attach to the IAM role in `{'static_name' = 'policy_arn'}` format.
- `ami_id_ssm_parameter_arns` [`variable.ami_id_ssm_parameter_arns()`](variables.tf:107): List of SSM Parameter ARNs that Karpenter controller is allowed read access (for retrieving AMI IDs).
- `enable_pod_identity` [`variable.enable_pod_identity()`](variables.tf:113): Determines whether to enable support for EKS pod identity.
- `enable_v1_permissions` [`variable.enable_v1_permissions()`](variables.tf:120): Determines whether to enable permissions suitable for v1+ (`true`) or for v0.33.x-v0.37.x (`false`).
- `enable_irsa` [`variable.enable_irsa()`](variables.tf:130): Determines whether to enable support for IAM role for service accounts.
- `irsa_oidc_provider_arn` [`variable.irsa_oidc_provider_arn()`](variables.tf:136): OIDC provider arn used in trust policy for IAM role for service accounts.
- `irsa_namespace_service_accounts` [`variable.irsa_namespace_service_accounts()`](variables.tf:142): List of `namespace:serviceaccount`pairs to use in trust policy for IAM role for service accounts.
- `irsa_assume_role_condition_test` [`variable.irsa_assume_role_condition_test()`](variables.tf:148): Name of the IAM condition operator to evaluate when assuming the role.
- `create_pod_identity_association` [`variable.create_pod_identity_association()`](variables.tf:158): Determines whether to create pod identity association.
- `namespace` [`variable.namespace()`](variables.tf:164): Namespace to associate with the Karpenter Pod Identity.
- `service_account` [`variable.service_account()`](variables.tf:170): Service account to associate with the Karpenter Pod Identity.
- `enable_spot_termination` [`variable.enable_spot_termination()`](variables.tf:180): Determines whether to enable native spot termination handling.
- `queue_name` [`variable.queue_name()`](variables.tf:186): Name of the SQS queue.
- `queue_managed_sse_enabled` [`variable.queue_managed_sse_enabled()`](variables.tf:192): Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys.
- `queue_kms_master_key_id` [`variable.queue_kms_master_key_id()`](variables.tf:198): The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK.
- `queue_kms_data_key_reuse_period_seconds` [`variable.queue_kms_data_key_reuse_period_seconds()`](variables.tf:204): The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again.
- `create_node_iam_role` [`variable.create_node_iam_role()`](variables.tf:214): Determines whether an IAM role is created or to use an existing IAM role.
- `cluster_ip_family` [`variable.cluster_ip_family()`](variables.tf:220): The IP family used to assign Kubernetes pod and service addresses.
- `node_iam_role_arn` [`variable.node_iam_role_arn()`](variables.tf:226): Existing IAM role ARN for the IAM instance profile. Required if `create_iam_role` is set to `false`.
- `node_iam_role_name` [`variable.node_iam_role_name()`](variables.tf:232): Name to use on IAM role created.
- `node_iam_role_use_name_prefix` [`variable.node_iam_role_use_name_prefix()`](variables.tf:238): Determines whether the Node IAM role name (`node_iam_role_name`) is used as a prefix.
- `node_iam_role_path` [`variable.node_iam_role_path()`](variables.tf:244): IAM role path.
- `node_iam_role_description` [`variable.node_iam_role_description()`](variables.tf:250): Description of the role.
- `node_iam_role_max_session_duration` [`variable.node_iam_role_max_session_duration()`](variables.tf:256): Maximum API session duration in seconds between 3600 and 43200.
- `node_iam_role_permissions_boundary` [`variable.node_iam_role_permissions_boundary()`](variables.tf:262): ARN of the policy that is used to set the permissions boundary for the IAM role.
- `node_iam_role_attach_cni_policy` [`variable.node_iam_role_attach_cni_policy()`](variables.tf:268): Whether to attach the `AmazonEKS_CNI_Policy`/`AmazonEKS_CNI_IPv6_Policy` IAM policy to the IAM IAM role.
- `node_iam_role_additional_policies` [`variable.node_iam_role_additional_policies()`](variables.tf:274): Additional policies to be added to the IAM role.
- `node_iam_role_tags` [`variable.node_iam_role_tags()`](variables.tf:280): A map of additional tags to add to the IAM role created.
- `create_access_entry` [`variable.create_access_entry()`](variables.tf:290): Determines whether an access entry is created for the IAM role used by the node IAM role.
- `access_entry_type` [`variable.access_entry_type()`](variables.tf:296): Type of the access entry. `EC2_LINUX`, `FARGATE_LINUX`, or `EC2_WINDOWS`; defaults to `EC2_LINUX`.
- `create_instance_profile` [`variable.create_instance_profile()`](variables.tf:306): Whether to create an IAM instance profile.
- `rule_name_prefix` [`variable.rule_name_prefix()`](variables.tf:316): Prefix used for all event bridge rules.

**4. Outputs**
- `iam_role_name` [`output.iam_role_name()`](outputs.tf:5): The name of the controller IAM role.
- `iam_role_arn` [`output.iam_role_arn()`](outputs.tf:10): The Amazon Resource Name (ARN) specifying the controller IAM role.
- `iam_role_unique_id` [`output.iam_role_unique_id()`](outputs.tf:15): Stable and unique string identifying the controller IAM role.
- `queue_arn` [`output.queue_arn()`](outputs.tf:24): The ARN of the SQS queue.
- `queue_name` [`output.queue_name()`](outputs.tf:29): The name of the created Amazon SQS queue.
- `queue_url` [`output.queue_url()`](outputs.tf:34): The URL for the created Amazon SQS queue.
- `event_rules` [`output.event_rules()`](outputs.tf:43): Map of the event rules created and their attributes.
- `node_iam_role_name` [`output.node_iam_role_name()`](outputs.tf:52): The name of the node IAM role.
- `node_iam_role_arn` [`output.node_iam_role_arn()`](outputs.tf:57): The Amazon Resource Name (ARN) specifying the node IAM role.
- `node_iam_role_unique_id` [`output.node_iam_role_unique_id()`](outputs.tf:62): Stable and unique string identifying the node IAM role.
- `node_access_entry_arn` [`output.node_access_entry_arn()`](outputs.tf:71): Amazon Resource Name (ARN) of the node Access Entry.
- `instance_profile_arn` [`output.instance_profile_arn()`](outputs.tf:80): ARN assigned by AWS to the instance profile.
- `instance_profile_id` [`output.instance_profile_id()`](outputs.tf:85): Instance profile's ID.
- `instance_profile_name` [`output.instance_profile_name()`](outputs.tf:90): Name of the instance profile.
- `instance_profile_unique` [`output.instance_profile_unique()`](outputs.tf:95): Stable and unique string identifying the IAM instance profile.
- `namespace` [`output.namespace()`](outputs.tf:104): Namespace associated with the Karpenter Pod Identity.
- `service_account` [`output.service_account()`](outputs.tf:109): Service Account associated with the Karpenter Pod Identity.

**5. Resources Managed**
- [`aws_iam_role.controller`](main.tf:69)
- [`aws_iam_policy.controller`](main.tf:91)
- [`aws_iam_role_policy_attachment.controller`](main.tf:103)
- [`aws_iam_role_policy_attachment.controller_additional`](main.tf:110)
- [`aws_eks_pod_identity_association.karpenter`](main.tf:121)
- [`aws_sqs_queue.this`](main.tf:142)
- [`aws_sqs_queue_policy.this`](main.tf:193)
- [`aws_cloudwatch_event_rule.this`](main.tf:241)
- [`aws_cloudwatch_event_target.this`](main.tf:254)
- [`aws_iam_role.node`](main.tf:295)
- [`aws_iam_role_policy_attachment.node`](main.tf:312)
- [`aws_iam_role_policy_attachment.node_additional`](main.tf:326)
- [`aws_eks_access_entry.node`](main.tf:337)
- [`aws_iam_instance_profile.this`](main.tf:363)

**6. Test Environment Setup**
- Backend: local
- Credentials: `AWS_PROFILE`
- Fixtures: Separate directory named `test` inside the `modules/karpenter` directory.

**7. Sample Test Inputs**
```hcl
cluster_name = "my-eks-cluster"
tags = {
  Environment = "test"
}
```
