variable "ami" {
  default = null
  type    = string
}

variable "subnet_cidr" {
  type    = string
  default = "192.168.0.0/24"
}

variable "iam_instance_profile" {
  type    = string
  default = "SSM"
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}
