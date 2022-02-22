variable "vpc_id" {
  type = string

}

variable "cidr_blocks" {
  type = list(string)
}
variable "vpc_name" {
  type = string
}

variable "igw_id" {
  type = string
}
variable "default_tags" {
  type    = map(string)
  default = {}

}