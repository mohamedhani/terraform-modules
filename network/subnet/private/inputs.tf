variable "vpc_id" {
  type = string

}

variable "cidr_blocks" {
  type = list(string)
}
variable "project_name" {
  type = string
}

variable "instance_network_ids" {
  type = list(string)
}