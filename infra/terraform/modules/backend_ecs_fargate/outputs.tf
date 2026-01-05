output "ecr_repository_url" { value = aws_ecr_repository.backend.repository_url }
output "ecs_cluster_name" { value = aws_ecs_cluster.this.name }
output "ecs_service_name" { value = aws_ecs_service.this.name }
output "task_definition_family" { value = aws_ecs_task_definition.this.family }
output "task_execution_role_arn" { value = aws_iam_role.task_execution.arn }
output "task_role_arn" { value = aws_iam_role.task.arn }
output "alb_dns_name" { value = aws_lb.this.dns_name }
output "alb_arn" { value = aws_lb.this.arn }
output "target_group_arn" { value = aws_lb_target_group.this.arn }

output "ecr_repository_arn" { value = aws_ecr_repository.backend.arn }
output "ecs_cluster_arn" { value = aws_ecs_cluster.this.arn }
output "ecs_service_arn" { value = aws_ecs_service.this.arn }
