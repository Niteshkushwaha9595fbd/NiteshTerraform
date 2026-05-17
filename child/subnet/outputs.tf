output "name" {
  description = "Name of the Subnet"
  value       = azurerm_subnet.this.name
}

output "id" {
  description = "ID of the Subnet"
  value       = azurerm_subnet.this.id
}
