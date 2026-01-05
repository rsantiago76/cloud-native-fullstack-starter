provider "aws" {
  region = "us-east-1"
}

# Shared GitHub OIDC provider (created once)
data "tls_certificate" "github_actions_oidc" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions_oidc.certificates[0].sha1_fingerprint]
}

module "frontend_hosting" {
  source       = "./modules/frontend_s3_cloudfront"
  project_name = var.project_name
  tags         = var.tags
}

module "sns_github_oidc" {
  source = "./modules/sns_github_oidc"

  project_name           = var.project_name
  github_org             = var.github_org
  github_repo            = var.github_repo
  allowed_branches       = var.allowed_branches
  allow_tags             = true
  allow_pull_requests    = false

  oidc_provider_arn      = aws_iam_openid_connect_provider.github.arn

  sns_topic_name         = var.sns_topic_name
  sns_email_subscription = var.sns_email_subscription

  tags = var.tags
}

module "deploy_github_oidc_frontend" {
  source = "./modules/deploy_github_oidc_frontend"

  project_name               = var.project_name
  github_org                 = var.github_org
  github_repo                = var.github_repo
  allowed_branches           = var.allowed_branches
  allow_tags                 = true
  allow_pull_requests        = false

  oidc_provider_arn          = aws_iam_openid_connect_provider.github.arn
  frontend_bucket_arn        = module.frontend_hosting.bucket_arn
  cloudfront_distribution_arn = module.frontend_hosting.distribution_arn

  tags = var.tags
}
module "backend_ecs" {
  source       = "./modules/backend_ecs_fargate"
  project_name = var.project_name
  desired_count = var.backend_desired_count
  tags         = var.tags
}

module "deploy_github_oidc_backend" {
  source = "./modules/deploy_github_oidc_backend"

  project_name     = var.project_name
  github_org       = var.github_org
  github_repo      = var.github_repo
  allowed_branches = var.allowed_branches
  allow_tags       = true
  allow_pull_requests = false

  oidc_provider_arn      = aws_iam_openid_connect_provider.github.arn

  ecr_repository_arn     = module.backend_ecs.ecr_repository_arn
  ecs_cluster_arn        = module.backend_ecs.ecs_cluster_arn
  ecs_service_arn        = module.backend_ecs.ecs_service_arn
  task_execution_role_arn = module.backend_ecs.task_execution_role_arn
  task_role_arn          = module.backend_ecs.task_role_arn

  tags = var.tags
}
