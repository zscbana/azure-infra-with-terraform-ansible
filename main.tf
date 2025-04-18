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
module "Resource_Group" {
  source = "./modules/resource_group"
}

# Vnet module
module "Vnet" {
  source                = "./modules/virtual_network"
  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  france01RGName        = module.Resource_Group.france01RGName
  eastUS01RGName        = module.Resource_Group.eastUS01RGName

  hubWestEurope01RGLocation = module.Resource_Group.hubWestEurope01RGLocation
  france01RGLocation        = module.Resource_Group.france01RGLocation
  eastUS01RGLocation        = module.Resource_Group.eastUS01RGLocation
}

# Subnet module

module "Subnet" {
  source = "./modules/subnet"

  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  france01RGName        = module.Resource_Group.france01RGName
  eastUS01RGName        = module.Resource_Group.eastUS01RGName

  westEurope01VnetName = module.Vnet.westEurope01VnetName
  france01VnetName     = module.Vnet.france01VnetName
  eastUS01VnetName     = module.Vnet.eastUS01VnetName
}

module "nic" {
  source                = "./modules/nic"
  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  france01RGName        = module.Resource_Group.france01RGName
  eastUS01RGName        = module.Resource_Group.eastUS01RGName

  hubWestEurope01RGLocation = module.Resource_Group.hubWestEurope01RGLocation
  france01RGLocation        = module.Resource_Group.france01RGLocation
  eastUS01RGLocation        = module.Resource_Group.eastUS01RGLocation

  webApp01SubnetId  = module.Subnet.webApp01SubnetId
  ansible01SubnetId = module.Subnet.ansible01SubnetId
  web02SubnetId     = module.Subnet.web02SubnetId
}

module "nsg" {
  source                = "./modules/nsg"
  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  france01RGName        = module.Resource_Group.france01RGName
  eastUS01RGName        = module.Resource_Group.eastUS01RGName

  hubWestEurope01RGLocation = module.Resource_Group.hubWestEurope01RGLocation
  france01RGLocation        = module.Resource_Group.france01RGLocation
  eastUS01RGLocation        = module.Resource_Group.eastUS01RGLocation

  webApp01SubnetId  = module.Subnet.webApp01SubnetId
  ansible01SubnetId = module.Subnet.ansible01SubnetId
  web02SubnetId     = module.Subnet.web02SubnetId
}

module "Vms" {
  source = "./modules/vm"

  username = var.username
  password = var.password

  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  france01RGName        = module.Resource_Group.france01RGName
  eastUS01RGName        = module.Resource_Group.eastUS01RGName

  hubWestEurope01RGLocation = module.Resource_Group.hubWestEurope01RGLocation
  france01RGLocation        = module.Resource_Group.france01RGLocation
  eastUS01RGLocation        = module.Resource_Group.eastUS01RGLocation

  webapp01NIID = module.nic.webapp01NIID
  webapp02NIID = module.nic.webapp02NIID
  webapp03NIID = module.nic.webapp03NIID
  webapp04NIID = module.nic.webapp04NIID
  ansible01NIID = module.nic.ansible01NIID
}

module "Ips" {
  source = "./modules/public_ip"

  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  france01RGName        = module.Resource_Group.france01RGName
  eastUS01RGName        = module.Resource_Group.eastUS01RGName

  hubWestEurope01RGLocation = module.Resource_Group.hubWestEurope01RGLocation
  france01RGLocation        = module.Resource_Group.france01RGLocation
  eastUS01RGLocation        = module.Resource_Group.eastUS01RGLocation
}

module "LB" {
  source = "./modules/public_lb"
  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  france01RGName        = module.Resource_Group.france01RGName
  eastUS01RGName        = module.Resource_Group.eastUS01RGName

  hubWestEurope01RGLocation = module.Resource_Group.hubWestEurope01RGLocation
  france01RGLocation        = module.Resource_Group.france01RGLocation
  eastUS01RGLocation        = module.Resource_Group.eastUS01RGLocation

  FranceLoadBalancerPubIP = module.Ips.FranceLoadBalancerPubIP
  EastUSLoadBalancerPubIP = module.Ips.EastUSLoadBalancerPubIP
  
  FranceLoadBalancerPubIPID = module.Ips.FranceLoadBalancerPubIPID
  EastUSLoadBalancerPubIPID = module.Ips.EastUSLoadBalancerPubIPID

  webapp01NIID = module.nic.webapp01NIID
  webapp02NIID = module.nic.webapp02NIID
  webapp03NIID = module.nic.webapp03NIID
  webapp04NIID = module.nic.webapp04NIID
}

module "HubBastion" {
  source = "./modules/bastion"

  hubWestEurope01RGName = module.Resource_Group.hubWestEurope01RGName
  hubWestEurope01RGLocation = module.Resource_Group.hubWestEurope01RGLocation

  HubBastionSubnetID = module.Subnet.HubBastionSubnetID
  HubBastionIPID = module.Ips.HubBastionIPID
}
