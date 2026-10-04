module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_private_access = true
  endpoint_public_access  = false

  authentication_mode = "API"

  enable_cluster_creator_admin_permissions = true

  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  create_cloudwatch_log_group            = true
  cloudwatch_log_group_retention_in_days = 30
  deletion_protection                    = var.environment == "prod"

  addons = {
    coredns = {
      most_recent = true
    }

    eks-pod-identity-agent = {
      before_compute = true
      most_recent    = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      before_compute = true
      most_recent    = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    application = {
      name = "${local.cluster_name}-application"

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"

      min_size     = var.node_min_size
      desired_size = var.node_desired_size
      max_size     = var.node_max_size

      update_config = {
        max_unavailable_percentage = 33
      }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"

          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = {
        role        = "application"
        environment = var.environment
      }

      tags = local.common_tags
    }
  }

  tags = local.common_tags
}
