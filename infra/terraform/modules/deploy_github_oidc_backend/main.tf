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

resource "aws_iam_role" "github_actions_backend_deployer" {
  name               = "${var.project_name}-github-actions-backend-deployer"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = merge(var.tags, { Project = var.project_name })
}

data "aws_iam_policy_document" "policy" {
  # ECR push
  statement {
    sid     = "ECRAuth"
    effect  = "Allow"
    actions = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid     = "ECRPushPull"
    effect  = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [var.ecr_repository_arn]
  }

  # ECS deployment
  statement {
    sid     = "ECSUpdateService"
    effect  = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]
    resources = [var.ecs_service_arn]
  }

  statement {
    sid     = "ECSRegisterTaskDef"
    effect  = "Allow"
    actions = [
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeTaskDefinition"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "ECSDescribeCluster"
    effect  = "Allow"
    actions = ["ecs:DescribeClusters"]
    resources = [var.ecs_cluster_arn]
  }

  # Allow passing the task roles used by the task definition
  statement {
    sid     = "PassTaskRoles"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [var.task_execution_role_arn, var.task_role_arn]
  }
}

resource "aws_iam_role_policy" "inline" {
  name   = "${var.project_name}-backend-deploy"
  role   = aws_iam_role.github_actions_backend_deployer.id
  policy = data.aws_iam_policy_document.policy.json
}
