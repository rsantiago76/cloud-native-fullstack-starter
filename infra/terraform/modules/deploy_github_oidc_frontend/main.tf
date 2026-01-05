locals {
  allowed_sub_patterns = concat(
    [for b in var.allowed_branches : "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${b}"],
    var.allow_tags ? ["repo:${var.github_org}/${var.github_repo}:ref:refs/tags/*"] : [],
    var.allow_pull_requests ? ["repo:${var.github_org}/${var.github_repo}:pull_request"] : []
  )
}

data "aws_iam_policy_document" "assume_role" {
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

resource "aws_iam_role" "github_actions_frontend_deployer" {
  name               = "${var.project_name}-github-actions-frontend-deployer"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(var.tags, { Project = var.project_name })
}

data "aws_iam_policy_document" "deploy_policy" {
  statement {
    sid     = "S3SyncFrontend"
    effect  = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [var.frontend_bucket_arn]
  }

  statement {
    sid     = "S3ObjectRW"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${var.frontend_bucket_arn}/*"]
  }

  statement {
    sid     = "CloudFrontInvalidation"
    effect  = "Allow"
    actions = ["cloudfront:CreateInvalidation"]
    resources = [var.cloudfront_distribution_arn]
  }
}

resource "aws_iam_role_policy" "deploy_inline" {
  name   = "${var.project_name}-frontend-deploy"
  role   = aws_iam_role.github_actions_frontend_deployer.id
  policy = data.aws_iam_policy_document.deploy_policy.json
}
