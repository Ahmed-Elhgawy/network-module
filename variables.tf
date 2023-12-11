variable "cidr" {
  type = string
}

variable "AZ" {
  type = list(string)
}

variable "vpc_name" {
  type = string
}

variable "subnet_mask" {
  type = number
}