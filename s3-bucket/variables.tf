variable "bucket_name" {
  type = string

}

variable "force_destroy" {

  type    = bool
  default = false
}

variable "enable_versioning" {
  type    = bool
  default = true

}
variable "expiration_days" {
  type    = number
  default = 60

}

variable "transition_days" {
  type    = number
  default = 30
}
variable "default_tags" {
  type    = map(string)
  default = {}

}