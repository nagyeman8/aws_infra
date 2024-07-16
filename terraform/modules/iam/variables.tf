variable "project_name" {
  type = string
}

variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "iam_override_tags" {
  type    = map(string)
  default = {}
}