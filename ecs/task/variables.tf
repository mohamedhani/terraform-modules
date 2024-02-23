variable "cluster_name" {
  type = string
}

variable "task_name" {
  type = string
}

variable "cpu" {
  type    = number
  default = 256
}

variable "image" {
  type = string

}

variable "role_arn" {
  type = string
}

variable "memory" {
  type    = number
  default = 512
}

variable "type" {
  type    = string
  default = "FARGATE"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "logs_retentions" {
  type    = number
  default = 7
}
variable "default_tags" {
  type    = map(string)
  default = {}
}