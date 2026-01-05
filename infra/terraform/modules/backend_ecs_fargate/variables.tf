variable "project_name" { type = string }
variable "container_port" { type = number, default = 8000 }
variable "desired_count" { type = number, default = 1 }
variable "tags" { type = map(string), default = {} }
