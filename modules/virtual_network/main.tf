resource "azurerm_virtual_network" "france01Vnet" {
  name                = "france01Vnet"
  location            = var.france01RGLocation
  resource_group_name = var.france01RGName
  address_space       = ["10.0.0.0/16"]

  tags = {
    Project = "terraform_ansible"
  }
}

resource "azurerm_virtual_network" "eastUS01Vnet" {
  name                = "eastUS01Vnet"
  location            = var.eastUS01RGLocation
  resource_group_name = var.eastUS01RGName
  address_space       = ["192.168.0.0/16"]

  tags = {
    Project = "terraform_ansible"
  }
}

resource "azurerm_virtual_network" "westEurope01Vnet" {
  name                = "westEurope01Vnet"
  location            = var.hubWestEurope01RGLocation
  resource_group_name = var.hubWestEurope01RGName
  address_space       = ["172.0.0.0/16"]

  tags = {
    Project = "terraform_ansible"
  }
}