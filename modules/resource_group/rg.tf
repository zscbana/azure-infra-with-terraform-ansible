locals {
  rg_map = { for item in var.locations : item.name => item.location }
}

resource "azurerm_resource_group" "Hub01RG" {
  name     = "westEurope01rg"
  location = local.rg_map["HubWestEurope01rg"]
  tags = {
    Project = "terraform_ansible"
  }
}

resource "azurerm_resource_group" "france01RG" {
  name     = "france01RG"
  location = local.rg_map["france01RG"]
  tags = {
    Project = "terraform_ansible"
  }
}

resource "azurerm_resource_group" "eastUS01RG" {
  name     = "eastUS01RG"
  location = local.rg_map["eastUS01RG"]
  tags = {
    Project = "terraform_ansible"
  }
}
