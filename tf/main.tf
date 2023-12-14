terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_region" "current" {
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_ecs_cluster" "hello-world-ecs" {
  name = "hello-world-cluster"
}

resource "aws_ecs_task_definition" "hello-world-ecs-task" {
  family                   = "hello-world-ecs-task"
  container_definitions = jsonencode([
    {
      name      = "hello-world"
      essential = true
      image     = "ghcr.io/babdor/curly-meme:latest"
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.helloWorldECSRole.arn
}

resource "aws_ecs_service" "hello-world-ecs-service" {
  name            = "hello-world-ecs-service"
  cluster         = aws_ecs_cluster.hello-world-ecs.id
  task_definition = aws_ecs_task_definition.hello-world-ecs-task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "hello-world"
    container_port   = 8080
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups = [
      aws_security_group.egress_all.id,
      aws_security_group.http.id,
    ]
  }
}

resource "aws_iam_role" "helloWorldECSRole" {
  name               = "helloWorldECSRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "helloWorldECSRole" {
  role       = aws_iam_role.helloWorldECSRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
