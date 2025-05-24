variable "name" {
  type = string
}
variable "rg" {
  type = string
}
variable "location" {
    type = string
}

variable "allocation_method" {
  type = string
  default = "Static"
}
variable "sku" {
  type = string
  default = "Standard"
}
variable "sku_tier" {
  type = string
  default = "Regional"
}