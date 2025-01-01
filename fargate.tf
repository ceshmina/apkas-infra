resource "aws_security_group" "fastapi_sample" {
  name = "fastapi-sample"
  vpc_id = aws_vpc.apkas.id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "fastapi_sample_inbound" {
  security_group_id = aws_security_group.fastapi_sample.id
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_iam_role" "fastapi_sample" {
  name = "fastapi-sample-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fastapi_sample_ecs" {
  role = aws_iam_role.fastapi_sample.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "fastapi_sample_ecr" {
  role = aws_iam_role.fastapi_sample.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_ecs_cluster" "fastapi_sample" {
  name = "fastapi-sample"
}

resource "aws_ecs_service" "fastapi_sample" {
  name = "fastapi-sample"
  cluster = aws_ecs_cluster.fastapi_sample.id
  launch_type = "FARGATE"
  task_definition = aws_ecs_task_definition.fastapi_sample.arn
  desired_count = 0
  network_configuration {
    subnets = [aws_subnet.fastapi_sample.id]
    security_groups = [aws_security_group.fastapi_sample.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "fastapi_sample" {
  family = "fastapi-sample"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.fastapi_sample.arn
  container_definitions = jsonencode([
    {
      name = "fastapi-sample"
      image = "${aws_ecr_repository.fastapi_sample.repository_url}:latest"
      portMappings = [
        {
          hostPort = 80
          containerPort = 80
          protocol = "tcp"
        }
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }
}
