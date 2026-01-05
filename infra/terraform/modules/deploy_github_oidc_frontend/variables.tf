variable "project_name" { type = string }
variable "github_org" { type = string }
variable "github_repo" { type = string }
variable "allowed_branches" { type = list(string) }
variable "allow_tags" { type = bool, default = true }
variable "allow_pull_requests" { type = bool, default = false }

variable "oidc_provider_arn" { type = string }

variable "frontend_bucket_arn" { type = string }
variable "cloudfront_distribution_arn" { type = string }

variable "tags" { type = map(string), default = {} }
