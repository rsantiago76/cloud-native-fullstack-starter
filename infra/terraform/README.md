# Terraform (us-east-1)

Creates:
- SNS topic (CI notifications)
- GitHub Actions OIDC provider
- IAM role (least-privilege) for SNS publish
- S3 + CloudFront hosting for frontend (SPA routing)
- IAM role (least-privilege) for **frontend deploy** (S3 sync + CloudFront invalidation)

## Deploy
```bash
terraform init
terraform apply
```

## Set GitHub Secrets (required)
From `terraform output`:

- `AWS_REGION` = `us-east-1`
- `SNS_TOPIC_ARN` = `sns_topic_arn`
- `AWS_ROLE_TO_ASSUME` = `github_actions_role_arn` (SNS publisher)

For frontend deploy workflow:
- `FRONTEND_BUCKET_NAME` = `frontend_bucket_name`
- `CLOUDFRONT_DISTRIBUTION_ID` = `cloudfront_distribution_id`
- `AWS_DEPLOY_ROLE_TO_ASSUME` = `github_actions_frontend_deploy_role_arn`

Optional:
- GitHub Variable `VITE_API_BASE_URL` for the deployed frontend to point to your API.


## Backend ECS deploy workflow (required secrets)
From `terraform output`:

- `AWS_BACKEND_DEPLOY_ROLE_TO_ASSUME` = `github_actions_backend_deploy_role_arn`
- `ECR_REPOSITORY_URL` = `backend_ecr_repository_url`
- `ECS_CLUSTER_NAME` = `backend_ecs_cluster_name`
- `ECS_SERVICE_NAME` = `backend_ecs_service_name`

Backend URL:
- `http://` + `backend_alb_dns_name`
