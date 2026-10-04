# AWS EKS Terraform GitOps Platform

[![Infrastructure CI](https://github.com/hemantsharma2189/aws-eks-terraform-gitops-platform/actions/workflows/ci.yml/badge.svg)](https://github.com/hemantsharma2189/aws-eks-terraform-gitops-platform/actions/workflows/ci.yml)
[![Security Scan](https://github.com/hemantsharma2189/aws-eks-terraform-gitops-platform/actions/workflows/security.yml/badge.svg)](https://github.com/hemantsharma2189/aws-eks-terraform-gitops-platform/actions/workflows/security.yml)
[![Terraform](https://img.shields.io/badge/Terraform-1.9-844FBA?logo=terraform)](https://developer.hashicorp.com/terraform)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-326CE5?logo=kubernetes)](https://kubernetes.io/)
[![GitOps](https://img.shields.io/badge/GitOps-Argo%20CD-EF7B4D?logo=argo)](https://argo-cd.readthedocs.io/)

Production-style AWS EKS platform designed with Terraform, Kubernetes, Helm, Argo CD, GitHub Actions, Prometheus and Grafana.

## Project overview

This project demonstrates how a secure, scalable and automated Kubernetes platform can be designed on AWS.

The repository includes:

- Multi-AZ AWS VPC with public and private subnets
- Amazon EKS cluster with managed worker nodes
- Amazon ECR container registry
- Encrypted and versioned Terraform remote state
- S3 native state locking
- Helm-based Kubernetes application deployment
- Argo CD automated GitOps synchronization
- Horizontal Pod Autoscaling
- Prometheus and Grafana monitoring configuration
- Terraform and Helm CI validation
- Trivy infrastructure security scanning

## Architecture

```mermaid
flowchart TB
    DEV[Developer] --> GH[GitHub]
    GH --> CI[CI and Security Scan]
    GH --> ARGO[Argo CD]

    TF[Terraform] --> VPC[AWS VPC]
    VPC --> EKS[Amazon EKS]
    TF --> ECR[Amazon ECR]
    TF --> S3[Remote State S3]

    ARGO --> EKS
    ECR --> EKS
    EKS --> APP[Helm Application]
    APP --> ALB[AWS Load Balancer]
    EKS --> MON[Prometheus and Grafana]
```

Detailed architecture: [docs/architecture.md](docs/architecture.md)

## Repository structure

```text
.
├── bootstrap/               # Secure S3 remote-state bootstrap
├── terraform/               # VPC, EKS, ECR and AWS infrastructure
├── helm/application/        # Secure application Helm chart
├── gitops/argocd/           # Argo CD application definition
├── gitops/monitoring/       # Prometheus and Grafana values
├── docs/                    # Architecture documentation
└── .github/workflows/       # CI validation and security scanning
```

## Security controls

- Private EKS API endpoint
- Private worker-node subnets
- Encrypted EBS volumes
- Immutable ECR image tags
- ECR image scanning
- EKS control-plane audit logging
- S3 state encryption and versioning
- Public-access blocking for Terraform state
- HTTPS-only S3 bucket policy
- Non-root Kubernetes containers
- Disabled service-account token mounting
- Dropped Linux container capabilities
- Trivy IaC security scanning
- GitHub Actions least-privilege permissions

## CI/CD and GitOps

Every push and pull request automatically performs:

1. Terraform formatting checks
2. Terraform initialization without remote backend
3. Terraform configuration validation
4. Helm chart linting
5. Kubernetes manifest rendering
6. Trivy Terraform and Kubernetes security scanning

Argo CD is configured to monitor the Helm chart and automatically:

- Synchronize Git changes
- Repair configuration drift
- Remove resources deleted from Git
- Create the application namespace

## Local validation

Format the Terraform configuration:

```bash
terraform fmt -recursive
```

Validate the bootstrap configuration:

```bash
terraform -chdir=bootstrap init -backend=false
terraform -chdir=bootstrap validate
```

Validate the main infrastructure:

```bash
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
```

Validate the Helm chart:

```bash
helm lint helm/application
helm template cloud-platform-app helm/application
```

## Important cost notice

This repository is an infrastructure portfolio project and does not deploy AWS resources automatically.

Amazon EKS, NAT Gateway, Application Load Balancer and worker nodes can create significant AWS charges. Review AWS pricing, configure billing alerts and understand every resource before running `terraform apply`.

## Project status

- Infrastructure code: Complete
- Terraform validation: Passing
- Helm validation: Passing
- Security scanning: Passing
- AWS deployment: Not performed
- Purpose: Portfolio, learning and infrastructure design demonstration
