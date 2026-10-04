output "aws_account_id" {
  description = "AWS account ID used by the platform."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region containing the platform."
  value       = var.aws_region
}

output "cluster_name" {
  description = "Amazon EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Amazon EKS API server endpoint."
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded EKS cluster certificate authority data."
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID used by the EKS platform."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs containing worker nodes."
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Public subnet IDs used for internet-facing load balancers."
  value       = module.vpc.public_subnets
}

output "ecr_repository_url" {
  description = "ECR repository URL for application images."
  value       = aws_ecr_repository.application.repository_url
}

output "configure_kubectl_command" {
  description = "AWS CLI command used to configure kubectl."
  value = join(
    " ",
    [
      "aws eks update-kubeconfig",
      "--region",
      var.aws_region,
      "--name",
      module.eks.cluster_name,
    ]
  )
}
