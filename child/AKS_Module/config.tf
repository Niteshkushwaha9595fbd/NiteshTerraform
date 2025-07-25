data "azurerm_resource_group" "rgs" {
  name = "AKS-rg"
  }




resource "azurerm_kubernetes_cluster" "example" {
  for_each = var.aks_rs
  name                = each.value.aks_name
  location            = data.azurerm_resource_group.rgs.location
  resource_group_name = data.azurerm_resource_group.rgs.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "node1"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  identity {
  type = "SystemAssigned"
}

 
}

resource "azurerm_kubernetes_cluster_node_pool" "example" {
  for_each = var.aks_rs
  
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example[each.key].id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1

  tags = {
    Environment = "Prod"
  }
}