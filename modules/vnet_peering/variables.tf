variable "name" {
  type = string
}
variable "rg" {
  type = string
}

variable "vnet_name" {
    type = string
    default = "vnet"
}

variable "vnet_id" {
  type = string
}

variable "allow_virtual_network_access" {
  type = bool
    default = true
}
variable "allow_forwarded_traffic" {
  type = bool
    default = true
}
variable "allow_gateway_transit" {
  type = bool
    default = false
}
