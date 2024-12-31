resource "aws_vpc" "apkas" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "apkas"
  }
}

resource "aws_internet_gateway" "apkas" {
  vpc_id = aws_vpc.apkas.id
  tags = {
    Name = "apkas"
  }
}

resource "aws_subnet" "fastapi_sample" {
  vpc_id = aws_vpc.apkas.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "fastapi-sample"
  }
}
