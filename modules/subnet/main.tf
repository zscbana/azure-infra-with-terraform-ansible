
resource "azurerm_subnet" "webApp01Subnet" {
  name                 = "webApp01Subnet"
  resource_group_name  = var.france01RGName
  virtual_network_name = var.france01VnetName
  address_prefixes     = ["10.0.1.0/24"]
}

# west europe subnet
resource "azurerm_subnet" "ansible01Subnet" {
  name                 = "ansible01Subnet"
  resource_group_name  = var.hubWestEurope01RGName
  virtual_network_name = var.westEurope01VnetName
  address_prefixes     = ["172.0.1.0/24"]
}

resource "azurerm_subnet" "HubBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.hubWestEurope01RGName
  virtual_network_name = var.westEurope01VnetName
  address_prefixes     = ["172.0.2.0/24"]
}

# East Us Subnets

resource "azurerm_subnet" "web02Subnet" {
  name                 = "web02Subnet"
  resource_group_name  = var.eastUS01RGName
  virtual_network_name = var.eastUS01VnetName
  address_prefixes     = ["192.168.2.0/24"]
}
