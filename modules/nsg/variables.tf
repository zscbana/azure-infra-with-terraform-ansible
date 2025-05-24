variable "name" {
  type = string
}
variable "rg" {
  type = string
}
variable "location" {
  type = string
}

variable "security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "subnet_id" {
  type = string
  default = null
}
