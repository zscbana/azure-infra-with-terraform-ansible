resource "azurerm_public_ip" "FranceLoadBalancerPubIP" {
  name                = "FranceLoadBalancerPubIP"
  resource_group_name = var.france01RGName
  location            = var.france01RGLocation
  allocation_method = "Static"
  sku       = "Standard"
  sku_tier  = "Regional"
}

resource "azurerm_public_ip" "EastUSLoadBalancerPubIP" {
  name                = "EastUSLoadBalancerPubIP"
  resource_group_name = var.eastUS01RGName
  location            = var.eastUS01RGLocation
  allocation_method = "Static"
  sku       = "Standard"
  sku_tier  = "Regional"
}
