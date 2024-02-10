variable "cluster_name" {
  type = string
}

variable "ng_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "node_group_sg_id" {
  type = string
}

variable "node_lables" {
  type    = map(string)
  default = {}
}

variable "node_taints" {
  type    = map(string)
  default = {}
}

variable "ebs_volume_size" {
  type    = number
  default = 30
}
variable "kubelet_extra_args" {
  type    = map(string)
  default = {}
}

variable "default_tags" {
  type    = map(string)
  default = {}
}
