variable "vpc_id" {
  type = string
}
variable "cluster_name" {
  type = string

}
variable "log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "scheduler"]

}
variable "eks_cluster_version" {
  type = string
}

variable "eks_private_access" {
  type    = bool
  default = true
}
variable "eks_public_access" {
  type    = bool
  default = false

}
variable "public_access_cidrs" {

  type    = list(string)
  default = ["0.0.0.0/0"]

}

variable "private_subnets_ids" {
  type        = list(string)
  description = "these are list of subnets where my worker node are in (private subnets ids)"
}
variable "service_cidr" {
  type    = string
  default = "172.16.0.0/16"

}
variable "default_tags" {
  type    = map(string)
  default = {}

}