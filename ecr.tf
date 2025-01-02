resource "aws_ecr_repository" "fastapi_sample_nginx" {
  name = "fastapi-sample/nginx"
}

resource "aws_ecr_repository" "fastapi_sample_python" {
  name = "fastapi-sample/python"
}
