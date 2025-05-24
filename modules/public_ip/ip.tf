resource "azurerm_public_ip" "PubIp" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location
  allocation_method = var.allocation_method
  sku       = var.sku
  sku_tier  = var.sku_tier
}