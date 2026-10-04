output "state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform remote state"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_region" {
  description = "AWS region containing the Terraform state bucket"
  value       = var.aws_region
}

output "backend_configuration" {
  description = "Values required for the Terraform S3 backend"
  value = {
    bucket       = aws_s3_bucket.terraform_state.id
    key          = "eks-gitops-platform/terraform.tfstate"
    region       = var.aws_region
    encrypt      = true
    use_lockfile = true
  }
}
