variable "name_prefix" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
