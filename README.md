# cloud-native-fullstack-starter

A production-minded **ALL-in-one** repo that signals **Frontend + Full-Stack + Cloud + DevSecOps**:

- **Frontend:** React + Vite + TypeScript + Tailwind
- **Backend:** FastAPI + JWT Auth + SQLAlchemy
- **CI/CD:** GitHub Actions (lint/test/build) + Semantic Versioning releases
- **AWS IaC:** Terraform (SNS + GitHub OIDC role) and **S3 + CloudFront** frontend hosting

## Quick start (local)

### Backend (dev)
```bash
cd backend
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux:
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Frontend (dev)
```bash
cd frontend
npm install
npm run dev
```

Frontend reads `VITE_API_BASE_URL` (defaults to `http://localhost:8000`).

## Terraform

```bash
cd infra/terraform
terraform init
terraform apply -var="github_org=rsantiago76" -var="github_repo=cloud-native-fullstack-starter"
```

After apply, set GitHub Secrets:
- `AWS_ROLE_TO_ASSUME` (terraform output)
- `AWS_REGION` = `us-east-1`
- `SNS_TOPIC_ARN` (terraform output)


## Deploy Backend (ECS Fargate)

1) Provision AWS resources:
```bash
cd infra/terraform
terraform init
terraform apply
```

2) Update the ECS task definition template once:
- Edit `infra/ecs/taskdef.json` and replace `REPLACE_EXECUTION_ROLE_ARN` and `REPLACE_TASK_ROLE_ARN` with Terraform outputs.

3) Set GitHub Secrets:
- `AWS_REGION` = `us-east-1`
- `AWS_BACKEND_DEPLOY_ROLE_TO_ASSUME` = `github_actions_backend_deploy_role_arn`
- `ECR_REPOSITORY_URL` = `backend_ecr_repository_url`
- `ECS_CLUSTER_NAME` = `backend_ecs_cluster_name`
- `ECS_SERVICE_NAME` = `backend_ecs_service_name`

Then push to `main` (or run workflow manually) to deploy.
