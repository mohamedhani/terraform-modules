variable "cluster_name" {
  type = string
}

variable "enable_container_insights" {
  type    = bool
  default = false

}

variable "logs_retentions" {
  type    = number
  default = 7
}

variable "default_tags" {
  type    = map(string)
  default = {}
}
