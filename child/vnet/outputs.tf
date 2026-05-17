output "vnet_id" {
  description = "ID of the created VNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the created VNet"
  value       = azurerm_virtual_network.vnet.name
}
