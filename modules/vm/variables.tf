variable "vm_name" {
  type = string
}
variable "rg" {
  type = string
}
variable "location" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "username" {
  description = "Admin username"
  type        = string
}

variable "password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "disable_password_authentication" {
  type = bool
  default = false
}

variable "nic_id" {
  description = "Network Interface ID for the VM"
  type        = string
}
