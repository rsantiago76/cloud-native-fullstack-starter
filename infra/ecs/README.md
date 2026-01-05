# ECS Task Definition Template

GitHub Actions uses `infra/ecs/taskdef.json` as a template and injects the Docker image.
Terraform outputs the role ARNs required by this task definition:

- task execution role: `module.backend_ecs.task_execution_role_arn`
- task role: `module.backend_ecs.task_role_arn`

After `terraform apply`, update `infra/ecs/taskdef.json`:

- Replace `REPLACE_EXECUTION_ROLE_ARN` with the execution role ARN output
- Replace `REPLACE_TASK_ROLE_ARN` with the task role ARN output

(You only do this once; after that deployments are fully automated.)
