variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "rg" {
    type = string
}
variable "subnet_id" {
  type = string
}

variable "private_ip_address_allocation" {
  type = string
  default = "Dynamic"
}

variable "private_ip_address" {
  type = string
}

variable "ip_configuration_name" {
  type = string
  default = "internal"
}