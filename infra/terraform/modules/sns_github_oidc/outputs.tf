output "sns_topic_arn" { value = aws_sns_topic.ci_notifications.arn }
output "github_actions_role_arn" { value = aws_iam_role.github_actions_sns_publisher.arn }
