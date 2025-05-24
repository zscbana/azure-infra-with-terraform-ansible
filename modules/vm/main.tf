
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.rg
  location            = var.location
  size                = var.vm_size
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids = [
    var.nic_id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    version   = "latest"
    sku       = "ubuntu-pro"
  }
}

