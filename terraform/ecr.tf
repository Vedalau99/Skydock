resource "aws_ecr_repository" "skydock_backend" {
  name                 = "skydock-backend"
  image_tag_mutability = "MUTABLE"

  lifecycle_policy {
    policy = jsonencode({
      rules = [
        {
          rulePriority = 1,
          description  = "Expire untagged images older than 7 days",
          selection    = {
            tagStatus     = "untagged"
            countType     = "sinceImagePushed"
            countUnit     = "days"
            countNumber   = 7
          },
          action = {
            type = "expire"
          }
        }
      ]
    })
  }
}
