provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

data "aws_caller_identity" "current" {}

locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "aws-eks-terraform-gitops-platform"
      Owner       = "Hemant-Sharma"
    },
    var.tags
  )

  cluster_name = "${var.project_name}-${var.environment}"
}
