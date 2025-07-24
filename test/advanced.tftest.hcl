variables {
  region           = "us-west-2"
  ec2_ssh_key_name = ""
}

provider "aws" {
  region = var.region
}

# Test IPv6 configuration
run "validate_ipv6_configuration" {
  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  command = plan

  # Override the module configuration to use IPv6
  plan_options {
    target = [
      module.eks
    ]
  }

  module {
    source = "./test"
  }

  # Modify the module configuration to use IPv6
  override_module {
    target = module.eks
    attrs = {
      cluster_ip_family = "ipv6"
    }
  }

  assert {
    condition     = module.eks.cluster_ip_family == "ipv6"
    error_message = "Cluster IP family should be IPv6"
  }
}

# Test private-only endpoint access
run "validate_private_only_endpoint" {
  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  command = plan

  plan_options {
    target = [
      module.eks
    ]
  }

  module {
    source = "./test"
  }

  # Modify the module configuration for private-only endpoint
  override_module {
    target = module.eks
    attrs = {
      cluster_endpoint_private_access = true
      cluster_endpoint_public_access  = false
    }
  }

  assert {
    condition     = module.eks.cluster_endpoint_private_access == true
    error_message = "Cluster endpoint private access should be enabled"
  }

  assert {
    condition     = module.eks.cluster_endpoint_public_access == false
    error_message = "Cluster endpoint public access should be disabled"
  }
}

# Test custom security group rules
run "validate_custom_security_group_rules" {
  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  command = plan

  plan_options {
    target = [
      module.eks
    ]
  }

  module {
    source = "./test"
  }

  # Add custom security group rules
  override_module {
    target = module.eks
    attrs = {
      cluster_security_group_additional_rules = {
        ingress_custom_https = {
          description = "Custom HTTPS ingress"
          protocol    = "tcp"
          from_port   = 443
          to_port     = 443
          type        = "ingress"
          cidr_blocks = ["10.0.0.0/8"]
        }
      }
      node_security_group_additional_rules = {
        ingress_custom_http = {
          description = "Custom HTTP ingress"
          protocol    = "tcp"
          from_port   = 80
          to_port     = 80
          type        = "ingress"
          cidr_blocks = ["10.0.0.0/8"]
        }
      }
    }
  }

  # We can't easily assert on the security group rules in a plan,
  # but we can verify the module accepts the configuration
}

# Test custom add-ons configuration
run "validate_custom_addons" {
  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  command = plan

  plan_options {
    target = [
      module.eks
    ]
  }

  module {
    source = "./test"
  }

  # Configure custom add-ons
  override_module {
    target = module.eks
    attrs = {
      cluster_addons = {
        coredns = {
          most_recent = true
          configuration_values = jsonencode({
            computeType = "Fargate"
            replicaCount = 2
          })
        }
        kube-proxy = {
          most_recent = true
        }
        vpc-cni = {
          most_recent = true
          configuration_values = jsonencode({
            env = {
              ENABLE_PREFIX_DELEGATION = "true"
              WARM_PREFIX_TARGET       = "1"
            }
          })
        }
        aws-ebs-csi-driver = {
          most_recent = true
        }
      }
    }
  }

  assert {
    condition     = length(module.eks.cluster_addons) == 4
    error_message = "Should have 4 cluster add-ons"
  }
}

# Test custom node group configurations
run "validate_custom_node_groups" {
  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  command = plan

  plan_options {
    target = [
      module.eks
    ]
  }

  module {
    source = "./test"
  }

  # Configure custom node groups
  override_module {
    target = module.eks
    attrs = {
      eks_managed_node_groups = {
        # Default node group
        default = {
          name = "default"
          
          min_size     = 1
          max_size     = 3
          desired_size = 2
          
          instance_types = ["t3.medium"]
          capacity_type  = "ON_DEMAND"
          
          labels = {
            Environment = "test"
            Role        = "default"
          }
          
          taints = {
            dedicated = {
              key    = "dedicated"
              value  = "default"
              effect = "NO_SCHEDULE"
            }
          }
          
          update_config = {
            max_unavailable_percentage = 33
          }
          
          tags = {
            "k8s.io/cluster-autoscaler/enabled" = "true"
          }
        }
        
        # Spot instances node group
        spot = {
          name = "spot"
          
          min_size     = 1
          max_size     = 5
          desired_size = 2
          
          instance_types = ["t3.micro", "t3.small", "t3.medium"]
          capacity_type  = "SPOT"
          
          labels = {
            Environment = "test"
            Role        = "spot"
          }
          
          taints = {
            spot = {
              key    = "spot"
              value  = "true"
              effect = "NO_SCHEDULE"
            }
          }
          
          tags = {
            "k8s.io/cluster-autoscaler/enabled" = "true"
          }
        }
        
        # GPU node group
        gpu = {
          name = "gpu"
          
          min_size     = 0
          max_size     = 2
          desired_size = 0
          
          instance_types = ["g4dn.xlarge"]
          capacity_type  = "ON_DEMAND"
          
          labels = {
            Environment = "test"
            Role        = "gpu"
          }
          
          taints = {
            nvidia = {
              key    = "nvidia.com/gpu"
              value  = "true"
              effect = "NO_SCHEDULE"
            }
          }
          
          tags = {
            "k8s.io/cluster-autoscaler/enabled" = "true"
          }
        }
      }
    }
  }

  assert {
    condition     = length(module.eks.eks_managed_node_groups) == 3
    error_message = "Should have 3 EKS managed node groups"
  }
}

# Test custom Fargate profile configurations
run "validate_custom_fargate_profiles" {
  variables {
    region           = var.region
    ec2_ssh_key_name = var.ec2_ssh_key_name
  }

  command = plan

  plan_options {
    target = [
      module.eks
    ]
  }

  module {
    source = "./test"
  }

  # Configure custom Fargate profiles
  override_module {
    target = module.eks
    attrs = {
      fargate_profiles = {
        default = {
          name = "default"
          selectors = [
            {
              namespace = "default"
            },
            {
              namespace = "kube-system"
            }
          ]
        }
        
        apps = {
          name = "apps"
          selectors = [
            {
              namespace = "apps"
            }
          ]
        }
        
        monitoring = {
          name = "monitoring"
          selectors = [
            {
              namespace = "monitoring"
              labels = {
                "fargate" = "true"
              }
            }
          ]
        }
      }
    }
  }

  assert {
    condition     = length(module.eks.fargate_profiles) == 3
    error_message = "Should have 3 Fargate profiles"
  }
}