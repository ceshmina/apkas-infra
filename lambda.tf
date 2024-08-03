resource "aws_lambda_function" "photos" {
  function_name = "photos-pipeline"
  architectures = ["arm64"]
  runtime = "python3.11"
  filename = "lambda_function.zip"
  handler = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("python/lambda_function.py")
  role = aws_iam_role.photos.arn
  memory_size = 1024
  timeout = 60
}

resource "aws_iam_role" "photos" {
  name = "photos-pipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "photos" {
  name = "photos-pipeline-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = ["${aws_s3_bucket.photos.arn}/original/*"]
      },
      {
        Effect = "Allow",
        Action = ["s3:PutObject"],
        Resource = [
          "${aws_s3_bucket.photos.arn}/large/*",
          "${aws_s3_bucket.photos.arn}/medium/*",
          "${aws_s3_bucket.photos.arn}/small/*",
          "${aws_s3_bucket.photos.arn}/thumbnail/*",
          "${aws_s3_bucket.photos.arn}/exif/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "photos" {
  role = aws_iam_role.photos.name
  policy_arn = aws_iam_policy.photos.arn
}
