# Assume this variable will always be /20 or larger (i.e. /19, /18, /17...)
variable "vpc_cidr" {
  description = "The IPv4 CIDR block to use for the VPC"
  type        = string
}

