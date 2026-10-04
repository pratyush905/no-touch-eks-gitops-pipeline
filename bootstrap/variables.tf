variable "aws_region" {
  description = "AWS region for the Terraform state resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "eks-gitops-platform"
}
