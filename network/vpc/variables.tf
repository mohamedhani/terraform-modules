variable "cidr_block" {
  type = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "vpc_name" {
  type = string
}
variable "default_tags" {
  type=map(string)
  default = {}
}
