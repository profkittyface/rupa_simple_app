# Create ECR Repo and output the path
resource "aws_ecr_repository" "rupa_ecr" {
  name = "rupa-simple-app"
}

resource "aws_ecs_cluster" "rupa_cluster" {
  name = "rupa_cluster"
}

# Task definition
resource "aws_ecs_task_definition" "rupa_task" {
  family = "rupa-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  task_role_arn            = aws_iam_role.ecs_tasks_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "rupa-simple-app"
      image     = "${aws_ecr_repository.rupa_ecr.repository_url}:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    }
  ])
}

# Service
resource "aws_ecs_service" "rupa_service" {
  name            = "rupa_service"
  cluster         = aws_ecs_cluster.rupa_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.rupa_task.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.rupa_lb_tg.arn
    container_name   = "rupa-simple-app"
    container_port   = 8080
  }

  network_configuration {
    security_groups = [aws_security_group.rupa_simple_app_sg.id]
    subnets         = [aws_subnet.public.id]
    assign_public_ip = true
  }
}
