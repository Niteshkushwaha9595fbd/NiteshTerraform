output "subnet_id" {
  description = "ID of the created Subnet"
  value       = azurerm_subnet.subnet.id
}

output "subnet_name" {
  description = "Name of the created Subnet"
  value       = azurerm_subnet.subnet.name
}
