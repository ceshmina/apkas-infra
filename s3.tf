resource "aws_s3_bucket" "photos" {
  bucket = "apkas-photos"
}

resource "aws_s3_bucket_public_access_block" "photos" {
  bucket = aws_s3_bucket.photos.bucket
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "photos" {
  bucket = aws_s3_bucket.photos.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = "*",
      Action = ["s3:GetObject"],
      Resource = ["${aws_s3_bucket.photos.arn}/*"]
    }]
  })
}

resource "aws_s3_bucket_notification" "photos_put" {
  bucket = aws_s3_bucket.photos.bucket
  lambda_function {
    lambda_function_arn = aws_lambda_function.photos_pipeline.arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "original/"
    filter_suffix = ".jpg"
  }
}
