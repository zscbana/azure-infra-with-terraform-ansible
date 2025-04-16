
resource "azurerm_network_interface" "webapp01NI" {
  name                = "webapp01NI"
  location            = var.france01RGLocation
  resource_group_name = var.france01RGName

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.webApp01SubnetId
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4"
  }
}

resource "azurerm_network_interface" "webapp02NI" {
  name                = "webapp02NI"
  location            = var.france01RGLocation
  resource_group_name = var.france01RGName

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.webApp01SubnetId
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
  }
}

# West Europe network interface 
resource "azurerm_public_ip" "ansilbe01PIP" {
  name                = "ansilbe01PIP"
  resource_group_name = var.hubWestEurope01RGName
  location            = var.hubWestEurope01RGLocation
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ansible01NI" {
  name                = "ansible01NI"
  location            = var.hubWestEurope01RGLocation
  resource_group_name = var.hubWestEurope01RGName

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.ansible01SubnetId
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.0.1.5"
    public_ip_address_id          = azurerm_public_ip.ansilbe01PIP.id
  }
}
# East us network interface

resource "azurerm_network_interface" "webapp03NI" {
  name                = "webapp03NI"
  location            = var.eastUS01RGLocation
  resource_group_name = var.eastUS01RGName

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.web02SubnetId
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.2.4"
  }
}

resource "azurerm_network_interface" "webapp04NI" {
  name                = "webapp04NI"
  location            = var.eastUS01RGLocation
  resource_group_name = var.eastUS01RGName

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.web02SubnetId
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.2.5"
  }
}
