
# France Vm
resource "azurerm_linux_virtual_machine" "webapp01vm" {
  name                = "webapp01vm"
  resource_group_name = azurerm_resource_group.france01RG.name
  location            = azurerm_resource_group.france01RG.location
  size                = "Standard_B1s"
  admin_username      = "demoadmin"
  admin_password      = "@demopassword123"
  network_interface_ids = [
    azurerm_network_interface.webapp01NI.id,
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
  resource_group_name = azurerm_resource_group.france01RG.name
  location            = azurerm_resource_group.france01RG.location
  size                = "Standard_B1s"
  admin_username      = "demoadmin"
  admin_password      = "@demopassword123"
  network_interface_ids = [
    azurerm_network_interface.webapp02NI.id,
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
  resource_group_name = azurerm_resource_group.eastUS01RG.name
  location            = azurerm_resource_group.eastUS01RG.location
  size                = "Standard_B1s"
  admin_username      = "demoadmin"
  admin_password      = "@demopassword123"
  network_interface_ids = [
    azurerm_network_interface.webapp03NI.id,
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
  resource_group_name = azurerm_resource_group.eastUS01RG.name
  location            = azurerm_resource_group.eastUS01RG.location
  size                = "Standard_B1s"
  admin_username      = "demoadmin"
  admin_password      = "@demopassword123"
  network_interface_ids = [
    azurerm_network_interface.webapp04NI.id,
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
  resource_group_name = azurerm_resource_group.Hub01RG.name
  location            = azurerm_resource_group.Hub01RG.location
  size                = "Standard_B1s"
  admin_username      = "demoadmin"
  admin_password      = "@demopassword123"
  network_interface_ids = [
    azurerm_network_interface.ansible01NI.id,
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
