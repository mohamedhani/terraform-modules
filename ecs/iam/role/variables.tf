variable "cluster_name" {
  type = string
}

variable "task_name" {
  type = string
}

variable "configs" {
  type = object({
    dynamodb_tables = list(string)
  })
}

variable "default_tags" {
  type    = map(string)
  default = {}
}