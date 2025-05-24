output "public_ip_id" {
  value = azurerm_public_ip.PubIp.id
}

output "public_ip_address" {
  value = azurerm_public_ip.PubIp.ip_address
}
