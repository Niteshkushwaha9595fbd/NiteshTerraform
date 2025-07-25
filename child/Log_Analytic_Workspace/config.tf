data "azurerm_resource_group" "rgs" {
  name = "AKS-rg"
  }

resource "azurerm_log_analytics_workspace" "example" {
    for_each = var.log_analytic
  name                = each.key.value.l_name
  location            = data.azurerm_resource_group.rgs.name
  resource_group_name = data.azurerm_resource_group.rgs.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}