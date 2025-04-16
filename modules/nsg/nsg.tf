resource "azurerm_network_security_group" "webNSG01" {
  name                = "webNSG01"
  location            = var.france01RGLocation
  resource_group_name = var.france01RGName

  security_rule {
    name                       = "AllowAppGatewayHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAppGatewayHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = {
    environment = "Web"
  }
}

resource "azurerm_network_security_group" "webNSG02" {
  name                = "webNSG02"
  location            = var.eastUS01RGLocation
  resource_group_name = var.eastUS01RGName

  security_rule {
    name                       = "AllowAppGatewayHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAppGatewayHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = {
    environment = "Web"
  }
}


resource "azurerm_network_security_group" "anisble01NSG" {
  name                = "anisble01NSG"
  location            = var.hubWestEurope01RGLocation
  resource_group_name = var.hubWestEurope01RGName

  security_rule {
    name                       = "AllowSSHFromInternet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowInternetOut"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = {
    environment = "Ansible"
  }
}


# NSG association

# East us
resource "azurerm_subnet_network_security_group_association" "Asso02" {
  subnet_id                 = var.web02SubnetId
  network_security_group_id = azurerm_network_security_group.webNSG02.id
}

# France 
resource "azurerm_subnet_network_security_group_association" "Asso01" {
  subnet_id                 = var.webApp01SubnetId
  network_security_group_id = azurerm_network_security_group.webNSG01.id
}

# West Europe 
resource "azurerm_subnet_network_security_group_association" "ansibleAsso" {
  subnet_id                 = var.ansible01SubnetId
  network_security_group_id = azurerm_network_security_group.anisble01NSG.id
}
