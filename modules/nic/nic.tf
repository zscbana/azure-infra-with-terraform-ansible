
resource "azurerm_network_interface" "Nic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
  }
}
