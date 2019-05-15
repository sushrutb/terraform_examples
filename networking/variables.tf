variable "domain_name" {
  default = "youdomainname.com"
}

variable "region" {
  default = "ap-southeast-1"
  # Singapore.
}

variable "availability_zones" {
  type    = "list"
  default = [
    "a", "b", "c"
  ]
}

variable "access_key" {}
variable "secret_key" {}
