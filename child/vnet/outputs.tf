output "name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}
