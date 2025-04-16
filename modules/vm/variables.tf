variable "username" {
  description = "Admin username"
  type        = string
}

variable "password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "hubWestEurope01RGName" {}
variable "france01RGName" {}
variable "eastUS01RGName" {}

variable "hubWestEurope01RGLocation" {}
variable "france01RGLocation" {}
variable "eastUS01RGLocation" {}


variable "ansible01NIID" {}
variable "webapp01NIID" {}
variable "webapp02NIID" {}
variable "webapp03NIID" {}
variable "webapp04NIID" {}