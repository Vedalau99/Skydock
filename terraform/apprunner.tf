resource "aws_apprunner_service" "skydock_api" {
  service_name = "skydock-api"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.skydock_backend.repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port = "3000" # or whatever your backend exposes
      }
    }

    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu    = "1024" # 1 vCPU
    memory = "2048" # 2 GB RAM
  }

  tags = {
    Project = "SkyDock"
  }
}
resource "aws_iam_role" "apprunner_ecr_access" {
  name = "apprunner-ecr-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.apprunner_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_apprunner_observability_configuration" "skydock_logs" {
  observability_configuration_name = "skydock-observability"
  trace_configuration {
    vendor = "AWSXRAY"
  }

  lifecycle {
    create_before_destroy = true
  }
}
