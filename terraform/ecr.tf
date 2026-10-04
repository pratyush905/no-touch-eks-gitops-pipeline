resource "aws_ecr_repository" "application" {
  name = "${local.cluster_name}-application"

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = local.common_tags
}

resource "aws_ecr_lifecycle_policy" "application" {
  repository = aws_ecr_repository.application.name

  policy = jsonencode(
    {
      rules = [
        {
          rulePriority = 1
          description  = "Remove untagged images after seven days"

          selection = {
            tagStatus   = "untagged"
            countType   = "sinceImagePushed"
            countUnit   = "days"
            countNumber = 7
          }

          action = {
            type = "expire"
          }
        },
        {
          rulePriority = 2
          description  = "Keep the latest thirty tagged images"

          selection = {
            tagStatus     = "tagged"
            tagPrefixList = ["v", "sha-"]
            countType     = "imageCountMoreThan"
            countNumber   = 30
          }

          action = {
            type = "expire"
          }
        }
      ]
    }
  )
}
