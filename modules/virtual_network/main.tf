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

# West Euro to france peering and france to west euro

resource "azurerm_virtual_network_peering" "peering_WestEurope2France" {
  name                         = "peering_WestEurope2France"
  resource_group_name          = var.hubWestEurope01RGName
  virtual_network_name         = azurerm_virtual_network.westEurope01Vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.france01Vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "peering_France2WestEurope" {
  name                         = "peering_France2WestEurope"
  resource_group_name          = var.france01RGName
  virtual_network_name         = azurerm_virtual_network.france01Vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.westEurope01Vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

# West Euro Hub to East US peering

resource "azurerm_virtual_network_peering" "peering_WestEurope2EastUS" {
  name                         = "peering_WestEurope2EastUS"
  resource_group_name          = var.hubWestEurope01RGName
  virtual_network_name         = azurerm_virtual_network.westEurope01Vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.eastUS01Vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "peering_EastUS2WestEurope" {
  name                         = "peering_EastUS2WestEurope"
  resource_group_name          = var.eastUS01RGName
  virtual_network_name         = azurerm_virtual_network.eastUS01Vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.westEurope01Vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}
