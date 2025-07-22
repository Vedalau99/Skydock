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
        port = "3000"
      }
    }

    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  observability_configuration {
    observability_enabled           = true
    observability_configuration_arn = aws_apprunner_observability_configuration.skydock_obs_config.arn
  }

  tags = {
    Project = "SkyDock"
  }
}

#  App Runner needs ECR access
resource "aws_iam_role" "apprunner_ecr_access" {
  name = "apprunner-ecr-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#  App Runner needs logging access
resource "aws_iam_role" "apprunner_logging_access" {
  name = "apprunner-logging-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#  Log policy for logging role
resource "aws_iam_role_policy" "apprunner_logs_policy" {
  name = "apprunner-logs-policy"
  role = aws_iam_role.apprunner_logging_access.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

#  Attach managed policy for ECR pull access
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.apprunner_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

#  Observability configuration (must be outside service)
resource "aws_apprunner_observability_configuration" "skydock_obs_config" {
  observability_configuration_name = "skydock-logs"

  trace_configuration {
    vendor = "AWSXRAY"
  }
}
