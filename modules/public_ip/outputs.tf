output "FranceLoadBalancerPubIPID" {
  value = azurerm_public_ip.FranceLoadBalancerPubIP.id
}
output "EastUSLoadBalancerPubIPID" {
  value = azurerm_public_ip.EastUSLoadBalancerPubIP.id
}
output "HubBastionIPID" {
  value = azurerm_public_ip.HubBastionIP.id
}


output "FranceLoadBalancerPubIP" {
  value = azurerm_public_ip.FranceLoadBalancerPubIP.ip_address
}
output "EastUSLoadBalancerPubIP" {
  value = azurerm_public_ip.EastUSLoadBalancerPubIP.ip_address
}
output "HubBastionIP" {
  value = azurerm_public_ip.HubBastionIP.ip_address
}

