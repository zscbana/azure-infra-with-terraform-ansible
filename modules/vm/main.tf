
# France Vm
resource "azurerm_linux_virtual_machine" "webapp01vm" {
  name                = "webapp01vm"
  resource_group_name = var.france01RGName
  location            = var.france01RGLocation
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false
  network_interface_ids = [
    var.webapp01NIID,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "webapp02vm" {
  name                = "webapp02vm"
  resource_group_name = var.france01RGName
  location            = var.france01RGLocation
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false
  network_interface_ids = [
    var.webapp02NIID,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# East us Vm
resource "azurerm_linux_virtual_machine" "webapp03vm" {
  name                = "webapp03vm"
  resource_group_name = var.eastUS01RGName
  location            = var.eastUS01RGLocation
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false
  network_interface_ids = [
    var.webapp03NIID,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "webapp04vm" {
  name                = "webapp04vm"
  resource_group_name = var.eastUS01RGName
  location            = var.eastUS01RGLocation
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false
  network_interface_ids = [
    var.webapp04NIID,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# West Europe Ansible vm
resource "azurerm_linux_virtual_machine" "anssible01vm" {
  name                = "anssible01vm"
  resource_group_name = var.hubWestEurope01RGName
  location            = var.hubWestEurope01RGLocation
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false

  network_interface_ids = [
    var.ansible01NIID,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
