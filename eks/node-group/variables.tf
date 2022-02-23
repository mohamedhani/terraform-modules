variable "cluster_name" {
  type = string

}


variable "instance_type" {

  type    = string
  default = "t2.medium"

}

variable "node_group_sg_id" {
  type = string
}

variable "public_key" {
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

variable "ami_id" {
  type = string
}
variable "default_tags" {
  type    = map(string)
  default = {}

}

variable "node_taints" {
  type = list(object({ name = string,
    value = string,
  type = string }))
  default = []
}

variable "node_lables" {
  type    = map(string)
  default = {}
}
variable "kubelet_extra_args" {
  type    = map(string)
  default = {}

}