variable "project_name" {
  type    = string
  default = "cloud-native-fullstack-starter"
}

variable "github_org" {
  type    = string
  default = "rsantiago76"
}

variable "github_repo" {
  type    = string
  default = "cloud-native-fullstack-starter"
}

variable "allowed_branches" {
  type    = list(string)
  default = ["main"]
}

variable "sns_topic_name" {
  type    = string
  default = "ci-notifications"
}

variable "sns_email_subscription" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "backend_desired_count" {
  type    = number
  default = 1
}
