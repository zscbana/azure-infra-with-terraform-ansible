variable "location" {
  type = string
}

variable "rg" {
  type = string
}

variable "sku" {
  type = string
  default = "Basic"
}

variable "subnet_id" {
  type = string
}

variable "public_ip_address_id" {
  type = string
}
