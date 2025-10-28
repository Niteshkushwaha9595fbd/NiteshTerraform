data "azurerm_resource_group" "Data1" {
    name = "Aks-rg"
  
}

resource "azurerm_kubernetes_cluster" "example" {
    for_each = var.Aks
  name                = each.value.aks_name
  location            = data.azurerm_resource_group.location
  resource_group_name = data.azurerm_resource_group.name
  dns_prefix          = each.value.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}