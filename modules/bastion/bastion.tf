resource "azurerm_bastion_host" "HubBastionHost" {
  name                = "HubBastionHost"
  location            = var.location
  resource_group_name = var.rg
  sku = var.sku

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
}

