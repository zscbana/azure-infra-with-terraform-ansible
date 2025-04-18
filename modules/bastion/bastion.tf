resource "azurerm_bastion_host" "HubBastionHost" {
  name                = "HubBastionHost"
  location            = var.hubWestEurope01RGLocation
  resource_group_name = var.hubWestEurope01RGName
  sku = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.HubBastionSubnetID
    public_ip_address_id = var.HubBastionIPID
  }
}
