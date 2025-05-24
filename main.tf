terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  backend "local" {
    path = "./state"
  }
}
provider "azurerm" {
  features {}
}

# RG module
module "Hub_WestEurope_rg" {
  source   = "./modules/resource_group"
  name     = "Hub_WestEurope_rg"
  location = "West Europe"
}

module "spoke1_France_rg" {
  source   = "./modules/resource_group"
  name     = "spoke1_France_rg"
  location = "France Central"
}

module "spoke2_EastUS_rg" {
  source   = "./modules/resource_group"
  name     = "spoke2_EastUS_rg"
  location = "East US"
}

# Public IP module
module "HubBastionIP" {
  source   = "./modules/public_ip"
  name     = "HubBastionIP"
  rg       = module.Hub_WestEurope_rg.name
  location = module.Hub_WestEurope_rg.location
}
module "FranceLoadBalancerPubIP" {
  source   = "./modules/public_ip"
  name     = "FranceLoadBalancerPubIP"
  rg       = module.spoke1_France_rg.name
  location = module.spoke1_France_rg.location
}
module "EastUSLoadBalancerPubIP" {
  source   = "./modules/public_ip"
  name     = "EastUSLoadBalancerPubIP"
  rg       = module.spoke2_EastUS_rg.name
  location = module.spoke2_EastUS_rg.location
}

module "NatPubIP" {
  source   = "./modules/public_ip"
  name     = "NatPubIP"
  rg       = module.Hub_WestEurope_rg.name
  location = module.Hub_WestEurope_rg.location
}

# Vnets 

module "Hub_WestEurope_Vnet" {
  source        = "./modules/virtual_network"
  name          = "Hub_WestEurope_Vnet"
  location      = module.Hub_WestEurope_rg.location
  rg            = module.Hub_WestEurope_rg.name
  address_space = ["172.0.0.0/16"]
}

module "spoke1_France_Vnet" {
  source        = "./modules/virtual_network"
  name          = "spoke1_France_Vnet"
  location      = module.spoke1_France_rg.location
  rg            = module.spoke1_France_rg.name
  address_space = ["10.0.0.0/16"]
}

module "spoke2_EastUS_Vnet" {
  source        = "./modules/virtual_network"
  name          = "spoke2_EastUS_Vnet"
  location      = module.spoke2_EastUS_rg.location
  rg            = module.spoke2_EastUS_rg.name
  address_space = ["192.168.0.0/16"]
}

# Vnet Peering

module "peering_HubWestEurope2France" {
  source    = "./modules/vnet_peering"
  name      = "peering_HubWestEurope2France"
  rg        = module.Hub_WestEurope_rg.name
  vnet_name = module.Hub_WestEurope_Vnet.vnet_name
  vnet_id   = module.spoke1_France_Vnet.vnet_id
  depends_on = [module.Hub_WestEurope_Vnet,
  module.spoke1_France_Vnet]
}

module "peering_France2HubWestEurope" {
  source    = "./modules/vnet_peering"
  name      = "peering_France2HubWestEurope"
  rg        = module.spoke1_France_rg.name
  vnet_name = module.spoke1_France_Vnet.vnet_name
  vnet_id   = module.Hub_WestEurope_Vnet.vnet_id
  depends_on = [module.Hub_WestEurope_Vnet,
  module.spoke1_France_Vnet]
}

# peering 
module "peering_HubWestEurope2EastUS" {
  source    = "./modules/vnet_peering"
  name      = "peering_HubWestEurope2EastUS"
  rg        = module.Hub_WestEurope_rg.name
  vnet_name = module.Hub_WestEurope_Vnet.vnet_name
  vnet_id   = module.spoke2_EastUS_Vnet.vnet_id
  depends_on = [module.Hub_WestEurope_Vnet,
  module.spoke2_EastUS_Vnet]
}

module "peering_EastUS2HubWestEurope" {
  source    = "./modules/vnet_peering"
  name      = "peering_HubWestEurope2EastUS"
  rg        = module.spoke2_EastUS_rg.name
  vnet_name = module.spoke2_EastUS_Vnet.vnet_name
  vnet_id   = module.Hub_WestEurope_Vnet.vnet_id
  depends_on = [module.Hub_WestEurope_Vnet,
  module.spoke1_France_Vnet]
}

# Subnets

module "webApp01Subnet" {
  source           = "./modules/subnet"
  name             = "webApp01Subnet"
  rg               = module.spoke1_France_rg.name
  vnet_name        = module.spoke1_France_Vnet.vnet_name
  address_prefixes = ["10.0.1.0/24"]
}

module "web02Subnet" {
  source           = "./modules/subnet"
  name             = "web02Subnet"
  rg               = module.spoke2_EastUS_rg.name
  vnet_name        = module.spoke2_EastUS_Vnet.vnet_name
  address_prefixes = ["192.168.2.0/24"]
}

module "ansible01Subnet" {
  source           = "./modules/subnet"
  name             = "ansible01Subnet"
  rg               = module.Hub_WestEurope_rg.name
  vnet_name        = module.Hub_WestEurope_Vnet.vnet_name
  address_prefixes = ["172.0.1.0/24"]
}

module "HubBastionSubnet" {
  source           = "./modules/subnet"
  name             = "AzureBastionSubnet"
  rg               = module.Hub_WestEurope_rg.name
  vnet_name        = module.Hub_WestEurope_Vnet.vnet_name
  address_prefixes = ["172.0.2.0/24"]
}

# NICs

module "ansible01NI" {
  source                        = "./modules/nic"
  name                          = "ansible01NI"
  location                      = module.Hub_WestEurope_rg.location
  rg                            = module.Hub_WestEurope_rg.name
  subnet_id                     = module.ansible01Subnet.subnet_id
  private_ip_address_allocation = "Static"
  private_ip_address            = "172.0.1.5"
}

module "webapp01NI" {
  source                        = "./modules/nic"
  name                          = "webapp01NI"
  location                      = module.spoke1_France_rg.location
  rg                            = module.spoke1_France_rg.name
  subnet_id                     = module.webApp01Subnet.subnet_id
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.0.1.4"
}

module "webapp02NI" {
  source                        = "./modules/nic"
  name                          = "webapp02NI"
  location                      = module.spoke1_France_rg.location
  rg                            = module.spoke1_France_rg.name
  subnet_id                     = module.webApp01Subnet.subnet_id
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.0.1.5"
}

module "webapp03NI" {
  source                        = "./modules/nic"
  name                          = "webapp03NI"
  location                      = module.spoke2_EastUS_rg.location
  rg                            = module.spoke2_EastUS_rg.name
  subnet_id                     = module.web02Subnet.subnet_id
  private_ip_address_allocation = "Static"
  private_ip_address            = "192.168.2.4"
}

module "webapp04NI" {
  source                        = "./modules/nic"
  name                          = "webapp04NI"
  location                      = module.spoke2_EastUS_rg.location
  rg                            = module.spoke2_EastUS_rg.name
  subnet_id                     = module.web02Subnet.subnet_id
  private_ip_address_allocation = "Static"
  private_ip_address            = "192.168.2.5"
}

# nsgs

module "webNSG01" {
  source    = "./modules/nsg"
  name      = "webNSG01"
  location  = module.spoke1_France_rg.location
  rg        = module.spoke1_France_rg.name
  subnet_id = module.webApp01Subnet.subnet_id

  security_rules = [
    {
      name                       = "AllowAppGatewayHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowAppGatewayHTTPS"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    { name                   = "AllowOutboundInternet"
      priority               = 200
      direction              = "Outbound"
      access                 = "Allow"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "*"
      source_address_prefix  = "*"
    destination_address_prefix = "Internet" },
  ]
}

module "webNSG02" {
  source    = "./modules/nsg"
  name      = "webNSG02"
  location  = module.spoke2_EastUS_rg.location
  rg        = module.spoke2_EastUS_rg.name
  subnet_id = module.web02Subnet.subnet_id

  security_rules = [
    {
      name                       = "AllowAppGatewayHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      }, { name                  = "AllowAppGatewayHTTPS"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
    destination_address_prefix = "*" },
    { name                   = "AllowOutboundInternet"
      priority               = 200
      direction              = "Outbound"
      access                 = "Allow"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "*"
      source_address_prefix  = "*"
    destination_address_prefix = "Internet" }
  ]
}

module "anisble01NSG" {
  source    = "./modules/nsg"
  name      = "anisble01NSG"
  location  = module.Hub_WestEurope_rg.location
  rg        = module.Hub_WestEurope_rg.name
  subnet_id = module.ansible01Subnet.subnet_id

  security_rules = [
    { name                   = "AllowSSHFromInternet"
      priority               = 100
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "*"
    destination_address_prefix = "*" },
    { name                   = "AllowInternetOut"
      priority               = 200
      direction              = "Outbound"
      access                 = "Allow"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "*"
      source_address_prefix  = "*"
    destination_address_prefix = "Internet" }
  ]
}

# NSG association

resource "azurerm_subnet_network_security_group_association" "Asso1" {
  subnet_id                 = module.webApp01Subnet.subnet_id
  network_security_group_id = module.webNSG01.nsg_id
}

resource "azurerm_subnet_network_security_group_association" "Asso2" {
  subnet_id                 = module.web02Subnet.subnet_id
  network_security_group_id = module.webNSG02.nsg_id
}

resource "azurerm_subnet_network_security_group_association" "ansibleAsso" {
  subnet_id                 = module.ansible01Subnet.subnet_id
  network_security_group_id = module.anisble01NSG.nsg_id
}

# vms 

module "webapp01vm" {
  source                          = "./modules/vm"
  vm_name                         = "webapp01vm"
  location                        = module.spoke1_France_rg.location
  rg                              = module.spoke1_France_rg.name
  nic_id                          = module.webapp01NI.NicId
  vm_size                         = "Standard_B1s"
  username                        = var.username
  password                        = var.password
  disable_password_authentication = false
}

module "webapp02vm" {
  source                          = "./modules/vm"
  vm_name                         = "webapp02vm"
  location                        = module.spoke1_France_rg.location
  rg                              = module.spoke1_France_rg.name
  nic_id                          = module.webapp02NI.NicId
  vm_size                         = "Standard_B1s"
  username                        = var.username
  password                        = var.password
  disable_password_authentication = false
}

module "webapp03vm" {
  source                          = "./modules/vm"
  vm_name                         = "webapp03vm"
  location                        = module.spoke2_EastUS_rg.location
  rg                              = module.spoke2_EastUS_rg.name
  nic_id                          = module.webapp03NI.NicId
  vm_size                         = "Standard_B1s"
  username                        = var.username
  password                        = var.password
  disable_password_authentication = false
}

module "webapp04vm" {
  source                          = "./modules/vm"
  vm_name                         = "webapp04vm"
  location                        = module.spoke2_EastUS_rg.location
  rg                              = module.spoke2_EastUS_rg.name
  nic_id                          = module.webapp04NI.NicId
  vm_size                         = "Standard_B1s"
  username                        = var.username
  password                        = var.password
  disable_password_authentication = false
}

module "anssible01vm" {
  source                          = "./modules/vm"
  vm_name                         = "anssible01vm"
  location                        = module.Hub_WestEurope_rg.location
  rg                              = module.Hub_WestEurope_rg.name
  nic_id                          = module.ansible01NI.NicId
  vm_size                         = "Standard_B1s"
  username                        = var.username
  password                        = var.password
  disable_password_authentication = false
}

# module bastion

module "HubBastionHost" {
  source               = "./modules/bastion"
  location             = module.Hub_WestEurope_rg.location
  rg                   = module.Hub_WestEurope_rg.name
  subnet_id            = module.HubBastionSubnet.subnet_id
  public_ip_address_id = module.HubBastionIP.public_ip_id
}

# Load Balancers

#France 
resource "azurerm_lb" "FranceLoadBalancer" {
  name                = "FranceLoadBalancer"
  location            = module.spoke1_France_rg.location
  resource_group_name = module.spoke1_France_rg.name
  sku                 = "Standard"
  sku_tier            = "Regional"
  frontend_ip_configuration {
    name                 = "PublicFranceFrontend"
    public_ip_address_id = module.FranceLoadBalancerPubIP.public_ip_id
  }
}

resource "azurerm_lb_backend_address_pool" "FranceLoadBalancerBackend" {
  name            = "FranceLoadBalancerBackend"
  loadbalancer_id = azurerm_lb.FranceLoadBalancer.id
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
  network_interface_id    = module.webapp01NI.NicId
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.FranceLoadBalancerBackend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "ipconfig1_web02" {
  network_interface_id    = module.webapp02NI.NicId
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.FranceLoadBalancerBackend.id
}

# East Us 

resource "azurerm_lb" "EastUSLoadBalancer" {
  name                = "EastUSLoadBalancer"
  location            = module.spoke2_EastUS_rg.location
  resource_group_name = module.spoke2_EastUS_rg.name
  sku                 = "Standard"
  sku_tier            = "Regional"
  frontend_ip_configuration {
    name                 = "PublicEastUSFrontend"
    public_ip_address_id = module.EastUSLoadBalancerPubIP.public_ip_id
  }
}

resource "azurerm_lb_backend_address_pool" "EastUSLoadBalancerBackend" {
  name            = "EastUSLoadBalancerBackend"
  loadbalancer_id = azurerm_lb.EastUSLoadBalancer.id
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
  network_interface_id    = module.webapp03NI.NicId
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.EastUSLoadBalancerBackend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "ipconfig1_web04" {
  network_interface_id    = module.webapp04NI.NicId
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.EastUSLoadBalancerBackend.id
}

# Traffic manager for global loadbalancing

resource "azurerm_traffic_manager_profile" "Traffic-Manager01" {
  name                   = "Traffic-Manager01"
  resource_group_name    = module.Hub_WestEurope_rg.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "projectdomaintest5050"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "Production"
  }
  depends_on = [
    azurerm_lb.FranceLoadBalancer,
    azurerm_lb.EastUSLoadBalancer,
    azurerm_traffic_manager_profile.Traffic-Manager01
  ]
}

resource "azurerm_traffic_manager_external_endpoint" "FranceEndpoint" {
  name              = "FranceEndpoint"
  profile_id        = azurerm_traffic_manager_profile.Traffic-Manager01.id
  endpoint_location = module.spoke1_France_rg.location
  weight            = 1
  target            = module.FranceLoadBalancerPubIP.public_ip_address
}

resource "azurerm_traffic_manager_external_endpoint" "EastUSEndpoint" {
  name              = "EastUSEndpoint"
  profile_id        = azurerm_traffic_manager_profile.Traffic-Manager01.id
  endpoint_location = module.spoke2_EastUS_rg.location
  weight            = 1
  target            = module.EastUSLoadBalancerPubIP.public_ip_address
}

resource "azurerm_nat_gateway" "HubNatGateway" {
  name                    = "HubNatGateway"
  location                = module.Hub_WestEurope_rg.location
  resource_group_name     = module.Hub_WestEurope_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "HubNatGatewayIp_association" {
  nat_gateway_id       = azurerm_nat_gateway.HubNatGateway.id
  public_ip_address_id = module.NatPubIP.public_ip_id
}

resource "azurerm_subnet_nat_gateway_association" "HubNatGatewaySubnet_association" {
  subnet_id      = module.ansible01Subnet.subnet_id
  nat_gateway_id = azurerm_nat_gateway.HubNatGateway.id
}
