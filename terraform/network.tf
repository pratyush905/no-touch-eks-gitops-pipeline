module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.7"

  name = "${local.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs = var.availability_zones

  public_subnets = [
    for index, az in var.availability_zones :
    cidrsubnet(var.vpc_cidr, 8, index)
  ]

  private_subnets = [
    for index, az in var.availability_zones :
    cidrsubnet(var.vpc_cidr, 8, index + 10)
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = !var.single_nat_gateway

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 30

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "karpenter.sh/discovery"          = local.cluster_name
  }

  tags = local.common_tags
}
