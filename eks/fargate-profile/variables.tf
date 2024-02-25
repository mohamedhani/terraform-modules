variable "name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
variable "labels" {
  type    = map(string)
  default = {}
}

variable "default_tags" {
  type    = map(string)
  default = {}
}