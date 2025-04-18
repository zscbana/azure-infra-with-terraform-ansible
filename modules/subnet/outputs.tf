output "webApp01SubnetId" {
  value = azurerm_subnet.webApp01Subnet.id
}

output "ansible01SubnetId" {
  value = azurerm_subnet.ansible01Subnet.id
}

output "HubBastionSubnetID" {
  value = azurerm_subnet.HubBastionSubnet.id
}

output "web02SubnetId" {
  value = azurerm_subnet.web02Subnet.id
}
