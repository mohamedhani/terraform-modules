locals {
  container_definitions = [
    {
      name      = var.task_name,
      image     = var.image,
      cpu       = var.cpu,
      memory    = var.memory
      essential = true,
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/${var.cluster_name}-${var.task_name}-task"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      },
    },

  ]
}