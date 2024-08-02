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
