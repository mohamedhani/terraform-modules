variable "cluster_name" {
  type = string
}

variable "ng_name" {
  type = string
}

variable "max_size" {
  type = number
}
variable "min_size" {
  type = number

}
variable "initial_size" {
  type = number
}

variable "launch_template_name" {
  type = string
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

