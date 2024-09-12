# Desired region
provider "aws" {
  region = var.aws_region
}

# create ECR Repo
resource "aws_ecr_repository" "example" {
  name = "${var.app_name}-repo"
}

# setup ECS Cluster and Task definition

resource "aws_ecs_cluster" "example" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "example" {
  family                = "${var.app_name}-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  container_definitions = jsonencode([{
    name  = "${var.app_name}"
    image = "${aws_ecr_repository.example.repository_url}:latest"
    essential = true
    logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.example.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
    }
    portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
          protocol      = "tcp"
        },
      ]
  }])
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

# log configuration

resource "aws_cloudwatch_log_group" "example" {
  name = "${var.app_name}-log-group"
}

# create ECS Service

resource "aws_ecs_service" "example" {
  name            = "${var.app_name}-ecs-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 1
  launch_type      = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups   = [aws_security_group.ecs.id]
    assign_public_ip  = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.example.arn
    container_name   = var.app_name
    container_port   = var.app_port
  }

}

# setup Code Pipeline

resource "aws_codebuild_project" "example" {
  name          = "${var.app_name}-build"
  source {
    type            = "GITHUB"
    location        = "https://github.com/robotweb/toplevel.git"
    buildspec       = "buildspec.yml"  # Define your buildspec file in the repo
    git_clone_depth = 1
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true  # Required for Docker builds
    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.example.repository_url
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  service_role = aws_iam_role.codebuild_service_role.arn
}

# codePipeline definition

resource "aws_codepipeline" "example" {
  name     = "${var.app_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.artifacts.id
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.example.name
        EnvironmentVariables = jsonencode([
          {
            name  = "AWS_REGION"
            value = var.aws_region
          },
          {
            name  = "REPOSITORY_URI"
            value = "${aws_ecr_repository.example.repository_url}"
          }
        ])
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      input_artifacts  = ["build_output"]
      version          = "1"
      configuration = {
        ClusterName        = aws_ecs_cluster.example.name
        ServiceName        = aws_ecs_service.example.name
        FileName           = "imagedefinitions.json"
      }
    }
  }
}

# define IAM roles

# role for task execution

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_logging_policy" {
  name        = "${var.app_name}-ECSLoggingPolicy"
  description = "Policy to allow ECS tasks to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_logging_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_logging_policy.arn
  role      = aws_iam_role.ecs_task_execution_role.name
}

# role for CodeBuild

resource "aws_iam_role" "codebuild_service_role" {
  name = "${var.app_name}-codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_service_policy" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"  # Adjust policy as needed
}

#role for codePipeline

resource "aws_iam_role" "codepipeline_service_role" {
  name = "${var.app_name}-codepipeline-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy_attachment" "codepipeline_ecs_policy" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "codebuild_ecs_policy" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# role for s3

resource "aws_iam_policy" "codepipeline_s3_policy" {
  name        = "${var.app_name}-codepipeline-s3-access"
  description = "Policy to allow CodePipeline to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
        ]
        Resource = [
          "arn:aws:s3:::${var.app_name}-pipeline-artifacts",
          "arn:aws:s3:::${var.app_name}-pipeline-artifacts/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_s3_attachment" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = aws_iam_policy.codepipeline_s3_policy.arn
}

# role for Build

resource "aws_iam_policy" "codebuild_start_build_policy" {
  name        = "${var.app_name}-CodeBuildStartBuildPolicy"
  description = "Policy to allow CodePipeline to start builds in CodeBuild"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects"
        ],
        Resource = aws_codebuild_project.example.arn
      },{
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        Resource = [
          "${aws_s3_bucket.artifacts.arn}",
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages",
          "ecr:DescribeRepositories",
          "ecr:ListRepositories",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = "*",
      },{
        Effect   = "Allow",
        Action   = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:ListServices",
          "ecs:ListTasks",
          "ecs:RunTask",
          "ecs:StopTask"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_start_build_policy.arn
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = aws_iam_policy.codebuild_start_build_policy.arn
}



# role for cloudwatch

resource "aws_iam_policy" "codebuild_cloudwatch_logs_policy" {
  name        = "${var.app_name}-CodeBuildCloudWatchLogsPolicy"
  description = "Policy to allow CodeBuild to manage CloudWatch Logs"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_cloudwatch_logs_attachment" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_cloudwatch_logs_policy.arn
}


# S3 bucket for artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.app_name}-pipeline-artifacts"  # Choose a unique bucket name
}

# Optionally, configure the bucket to enable versioning
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# subnets and security groups for ECS

# Configure vpc

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_name}-main-vpc"
  }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = element([var.availability_zone1, var.availability_zone2], count.index)

  tags = {
    Name = "${var.app_name}-public-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.app_name}-main-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count      = 2
  subnet_id  = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# Configure security groups

resource "aws_security_group" "lb" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Create target group

resource "aws_lb" "example" {
  name               = "${var.app_name}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "example" {
  name     = "${var.app_name}-target-group"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

   health_check {
    path                = "/"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

# Create listeners

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.example.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.aws_acm_certificate_arn  # Use an existing certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# New HTTPS listener (for SSL/TLS)
resource "aws_route53_record" "app_alias" {
  zone_id = var.aws_route53_zone_id
  name    = var.aws_route53_record_name # or leave as "example.com"
  type    = "A"

  alias {
    name                   = aws_lb.example.dns_name
    zone_id                = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}
