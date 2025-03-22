terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}
# Resource Groups

resource "azurerm_resource_group" "Hub01RG" {
  name     = "westEurope01rg"
  location = "West Europe"
  tags = {
    location = "West Europe"
  }
}

resource "azurerm_resource_group" "france01RG" {
  name     = "france01RG"
  location = "West Europe"
  tags = {
    location = "France Central"
  }
}

resource "azurerm_resource_group" "eastUS01RG" {
  name     = "eastUS01RG"
  location = "East US"
  tags = {
    location = "East US"
  }
}
# NSG
resource "azurerm_network_security_group" "webNSG01" {
  name                = "webNSG01"
  location            = azurerm_resource_group.france01RG.location
  resource_group_name = azurerm_resource_group.france01RG.name
}

resource "azurerm_network_security_group" "webNSG02" {
  name                = "webNSG02"
  location            = azurerm_resource_group.eastUS01RG.location
  resource_group_name = azurerm_resource_group.eastUS01RG.name
}

resource "azurerm_network_security_group" "anisble01NSG" {
  name                = "anisble01NSG"
  location            = azurerm_resource_group.Hub01RG.location
  resource_group_name = azurerm_resource_group.Hub01RG.name
}

# Vnet
resource "azurerm_virtual_network" "france01Vnet" {
  name                = "france01Vnet"
  location            = azurerm_resource_group.france01RG.location
  resource_group_name = azurerm_resource_group.france01RG.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    location = "France Central"
  }
}

resource "azurerm_virtual_network" "eastUS01Vnet" {
  name                = "eastUS01Vnet"
  location            = azurerm_resource_group.eastUS01RG.location
  resource_group_name = azurerm_resource_group.eastUS01RG.name
  address_space       = ["192.168.0.0/16"]

  tags = {
    location = "East US"
  }
}

resource "azurerm_virtual_network" "westEurope01Vnet" {
  name                = "westEurope01Vnet"
  location            = azurerm_resource_group.Hub01RG.location
  resource_group_name = azurerm_resource_group.Hub01RG.name
  address_space       = ["172.0.0.0/16"]

  tags = {
    location = "West Europe"
  }
}

# France Central Subnet

resource "azurerm_subnet" "webApp01Subnet" {
  name                 = "webApp01Subnet"
  resource_group_name  = azurerm_resource_group.france01RG.name
  virtual_network_name = azurerm_virtual_network.france01Vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# west europe subnet
resource "azurerm_subnet" "ansible01Subnet" {
  name                 = "ansible01Subnet"
  resource_group_name  = azurerm_resource_group.Hub01RG.name
  virtual_network_name = azurerm_virtual_network.westEurope01Vnet.name
  address_prefixes     = ["172.0.1.0/24"]
}

# East Us Subnets

resource "azurerm_subnet" "web02Subnet" {
  name                 = "web02Subnet"
  resource_group_name  = azurerm_resource_group.eastUS01RG.name
  virtual_network_name = azurerm_virtual_network.eastUS01Vnet.name
  address_prefixes     = ["192.168.2.0/24"]
}

# France Network interface


resource "azurerm_network_interface" "webapp01NI" {
  name                = "webapp01NI"
  location            = azurerm_resource_group.france01RG.location
  resource_group_name = azurerm_resource_group.france01RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.webApp01Subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.1"
  }
}

# West Europe network interface 
resource "azurerm_public_ip" "ansilbe01PIP" {
  name                = "ansilbe01PIP"
  resource_group_name = azurerm_resource_group.Hub01RG.name
  location            = azurerm_resource_group.Hub01RG.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ansible01NI" {
  name                = "ansible01NI"
  location            = azurerm_resource_group.Hub01RG.location
  resource_group_name = azurerm_resource_group.Hub01RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ansible01Subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.1"
    public_ip_address_id = azurerm_public_ip.ansilbe01PIP.id
  }
}
# East us network interface

resource "azurerm_network_interface" "webapp02NI" {
  name                = "webapp02NI"
  location            = azurerm_resource_group.eastUS01RG.location
  resource_group_name = azurerm_resource_group.eastUS01RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web02Subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "192.168.2.1"
  }
}

# NSG association

# East us
resource "azurerm_subnet_network_security_group_association" "Asso02" {
  subnet_id                 = azurerm_subnet.web02Subnet.id
  network_security_group_id = azurerm_network_security_group.webNSG02.id
}

# France 
resource "azurerm_subnet_network_security_group_association" "Asso01" {
  subnet_id                 = azurerm_subnet.webApp01Subnet.id
  network_security_group_id = azurerm_network_security_group.webNSG01.id
}

# West Europe 
resource "azurerm_subnet_network_security_group_association" "ansibleAsso" {
  subnet_id                 = azurerm_subnet.ansible01Subnet.id
  network_security_group_id = azurerm_network_security_group.anisble01NSG.id
}
