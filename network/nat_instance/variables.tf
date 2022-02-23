variable "subnet_ids" {
  type = list(string)

}
variable "vpc_id" {
  type = string
}
variable "key_pair_public_key" {
  type = string
}

variable "vpc_name" {
  type = string
}
variable "default_tags" {
  type    = map(string)
  default = {}
}