#France 
resource "azurerm_lb" "FranceLoadBalancer" {
  name = "FranceLoadBalancer"
  location = var.france01RGLocation
  resource_group_name = var.france01RGName
  sku = "Standard"
  sku_tier  = "Regional"
   frontend_ip_configuration {
    name                 = "PublicFranceFrontend"
    public_ip_address_id = var.FranceLoadBalancerPubIPID
  }
}

resource "azurerm_lb_backend_address_pool" "FranceLoadBalancerBackend" {
  name                = "FranceLoadBalancerBackend"
  loadbalancer_id     = azurerm_lb.FranceLoadBalancer.id
}

resource "azurerm_lb_rule" "http_rule_France" {
  name                           = "HttpRule"
  loadbalancer_id                = azurerm_lb.FranceLoadBalancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicFranceFrontend"
  probe_id                       = azurerm_lb_probe.http_probe_France.id
}

resource "azurerm_lb_probe" "http_probe_France" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.FranceLoadBalancer.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_network_interface_backend_address_pool_association" "ipconfig1_web01" {
  network_interface_id    = var.webapp01NIID
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.FranceLoadBalancerBackend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "ipconfig1_web02" {
  network_interface_id    = var.webapp02NIID
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.FranceLoadBalancerBackend.id
}

# East Us 

resource "azurerm_lb" "EastUSLoadBalancer" {
  name = "EastUSLoadBalancer"
  location = var.eastUS01RGLocation
  resource_group_name = var.eastUS01RGName
  sku = "Standard"
  sku_tier  = "Regional"
   frontend_ip_configuration {
    name                 = "PublicEastUSFrontend"
    public_ip_address_id = var.EastUSLoadBalancerPubIPID
  }
}

resource "azurerm_lb_backend_address_pool" "EastUSLoadBalancerBackend" {
  name                = "EastUSLoadBalancerBackend"
  loadbalancer_id     = azurerm_lb.EastUSLoadBalancer.id
}

resource "azurerm_lb_rule" "http_rule_EastUS" {
  name                           = "HttpRule"
  loadbalancer_id                = azurerm_lb.EastUSLoadBalancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicEastUSFrontend"
  probe_id                       = azurerm_lb_probe.http_probe_EastUS.id
}

resource "azurerm_lb_probe" "http_probe_EastUS" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.EastUSLoadBalancer.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_network_interface_backend_address_pool_association" "ipconfig1_web03" {
  network_interface_id    = var.webapp03NIID
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.EastUSLoadBalancerBackend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "ipconfig1_web04" {
  network_interface_id    = var.webapp04NIID
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.EastUSLoadBalancerBackend.id
}