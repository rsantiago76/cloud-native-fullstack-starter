output "sns_topic_arn" { value = module.sns_github_oidc.sns_topic_arn }
output "github_actions_role_arn" { value = module.sns_github_oidc.github_actions_role_arn }

output "frontend_bucket_name" { value = module.frontend_hosting.bucket_name }
output "cloudfront_domain_name" { value = module.frontend_hosting.cloudfront_domain_name }
output "cloudfront_distribution_id" { value = module.frontend_hosting.distribution_id }

output "github_actions_frontend_deploy_role_arn" {
  description = "Set this as GitHub Secret AWS_DEPLOY_ROLE_TO_ASSUME"
  value       = module.deploy_github_oidc_frontend.deploy_role_arn
}

output "aws_region" { value = "us-east-1" }


output "backend_alb_dns_name" {
  description = "Backend base URL: http://<alb_dns_name>"
  value       = module.backend_ecs.alb_dns_name
}

output "backend_ecr_repository_url" {
  value = module.backend_ecs.ecr_repository_url
}

output "backend_ecs_cluster_name" {
  value = module.backend_ecs.ecs_cluster_name
}

output "backend_ecs_service_name" {
  value = module.backend_ecs.ecs_service_name
}

output "github_actions_backend_deploy_role_arn" {
  description = "Set this as GitHub Secret AWS_BACKEND_DEPLOY_ROLE_TO_ASSUME"
  value       = module.deploy_github_oidc_backend.deploy_role_arn
}
