variable "cluster_name" {
    type =  string
}

variable "ng_name" {
  type = string
}

variable "ami_id" {
  type  = string
}

variable "instance_type" {
  type =  string
}

variable "node_group_sg_id" {
  type =  string
}

variable "additional_node_labels" {
  type = map(string)
  default = {}
}

variable "extra_settings" {
  type = map(string)
  default = {}
}

variable "max_pods" {
  type = number
}

variable "node_taints" {
  type = map(string)
  default = {}
}

variable "default_tags" {
  type    = map(string)
  default = {}
}