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

resource "aws_route_table" "apkas" {
  vpc_id = aws_vpc.apkas.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apkas.id
  }
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

resource "aws_route_table_association" "fastapi_sample" {
  subnet_id = aws_subnet.fastapi_sample.id
  route_table_id = aws_route_table.apkas.id
}
