# Create ECR repository for SkyDock backend container
resource "aws_ecr_repository" "skydock_backend" {
  name                 = "skydock-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true # Optional: allows easy cleanup
}

# Attach lifecycle policy to clean up untagged images after 7 days
resource "aws_ecr_lifecycle_policy" "expire_untagged_images" {
  repository = aws_ecr_repository.skydock_backend.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire untagged images older than 7 days",
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 7
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
