resource "aws_cloudwatch_log_group" "skydock_backend_logs" {
  name              = "/aws/apprunner/skydock-backend"
  retention_in_days = 7
}
