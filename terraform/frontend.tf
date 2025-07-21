resource "aws_s3_bucket" "frontend" {
  bucket = "skydock-frontend-bucket"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = "SkyDockFrontend"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls   = false
  block_public_policy = false

  # These 2 must be false to allow public access
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.frontend.arn}/*"
    }]
  })
}
