data "azurerm_resource_group" "Data1" {
    name = "Aks-rg"
  
}

resource "azurerm_kubernetes_cluster" "example" {
    for_each = var.Aks
  name                = each.value.aks_name
  location            = data.azurerm_resource_group.Data1.location
  resource_group_name = data.azurerm_resource_group.Data1.name
  dns_prefix          = each.value.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DC2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

