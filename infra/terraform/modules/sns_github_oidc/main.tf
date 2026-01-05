locals {
  allowed_sub_patterns = concat(
    [for b in var.allowed_branches : "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${b}"],
    var.allow_tags ? ["repo:${var.github_org}/${var.github_repo}:ref:refs/tags/*"] : [],
    var.allow_pull_requests ? ["repo:${var.github_org}/${var.github_repo}:pull_request"] : []
  )
}

resource "aws_sns_topic" "ci_notifications" {
  name = var.sns_topic_name
  tags = merge(var.tags, { Project = var.project_name })
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.sns_email_subscription != "" ? 1 : 0
  topic_arn = aws_sns_topic.ci_notifications.arn
  protocol  = "email"
  endpoint  = var.sns_email_subscription
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    sid     = "GitHubOIDCAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.allowed_sub_patterns
    }
  }
}

resource "aws_iam_role" "github_actions_sns_publisher" {
  name               = "${var.project_name}-github-actions-sns-publisher"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
  tags               = merge(var.tags, { Project = var.project_name })
}

data "aws_iam_policy_document" "sns_publish_only" {
  statement {
    sid     = "AllowPublishToCITopicOnly"
    effect  = "Allow"
    actions = ["sns:Publish"]
    resources = [aws_sns_topic.ci_notifications.arn]
  }
}

resource "aws_iam_role_policy" "sns_publish_inline" {
  name   = "${var.project_name}-sns-publish-only"
  role   = aws_iam_role.github_actions_sns_publisher.id
  policy = data.aws_iam_policy_document.sns_publish_only.json
}
