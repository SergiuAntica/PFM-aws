module "docker" {
  source  = "../modules-2/docker"
  name    = "hello"
  context = "../src-code-2"
}

module "ecr" {
  source              = "../modules-2/ecr"
  name                = "Repository"
  ecr_reg             = local.ecr_reg
  image_name          = module.docker.name
  image_src_path      = module.docker.context[0]
  image_tag           = module.docker.tag[0][0]
  force_delete        = true
  scan_on_push        = true
  force_image_rebuild = true
}

module "iam" {
  source = "../modules-2/iam-me"

  name        = "ecs-execution-task-role"
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  actions     = "sts:AssumeRole"
  type        = "Service"
  identifiers = "ecs-tasks.amazonaws.com"

  tags = {
    Name       = "ECS_ExecutionTaskRole"
    Enviroment = "Dev"
  }
}

module "sg" {
  source = "../modules-2/security_groups-me"

  name        = "ecs-security-group"
  description = "ECS Security Group"
  rules = {
    http = {
      "type" : "ingress"
      "from_port" : 80
      "to_port" : 80
      "protocol" : "tcp"
      "cidr_blocks" : ["0.0.0.0/0"]
    },
    egress = {
      "type" : "egress"
      "from_port" : 0
      "to_port" : 0
      "protocol" : "-1"
      "cidr_blocks" : ["0.0.0.0/0"]
    }
  }
}

module "alb" {
  source = "../modules-2/alb-me"

  alb_name           = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sg.id]

  alb_tags = {
    Name       = "ECS_ALB"
    Enviroment = "Dev"
  }

  alb_tg_name           = "ecs-alb-tg"
  alb_tg_port           = 80
  alb_tg_protocol       = "HTTP"
  target_type           = "ip"
  healthy_threshold     = "3"
  interval              = "30"
  health_check_protocol = "HTTP"
  matcher               = "200"
  timeout               = "3"
  path                  = "/"
  unhealthy_threshold   = "2"

  alb_tg_tags = {
    Name       = "ALB_Target_Groups"
    Enviroment = "Dev"
  }

  alb_listener_port     = 80
  alb_listener_protocol = "HTTP"
  alb_listener_type     = "forward"
}

module "ecs" {
  source = "../modules-2/ecs-me"

  cluster_name       = "butic"
  execution_role_arn = module.iam.arn_role
  capacity_providers = "FARGATE"
  family             = "butic-task-definition"
  image              = "nginx"
  memory             = 512
  cpu                = 256
  essential          = true
  protocol           = "tcp"
  container_name     = "nginx"
  container_port     = "80"
  hostPort           = "80"
  security_groups    = module.sg.id

  requires_compatibilities = "FARGATE"
  network_mode             = "awsvpc"

  service_name  = "butic-svc"
  launch_type   = "FARGATE"
  desired_count = 6

  target_group_arn = module.alb.target_group_arn
}

module "lg" {
  source = "../modules-2/log_group"

  log_group_name  = "hello-group-log"
  log_stream_name = "hello-stream-log"
}
