clusters = {
  prod = {
    location            = "East US"
    resource_group_name = "my-prod-rg"
    kubernetes_version  = "1.33"
    dns_prefix          = "myprodaks"
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
    }

    vnet = {
      name          = "my-prod-vnet"
      address_space = ["10.0.0.0/16"]
    }

    subnet = {
      name             = "my-aks-subnet"
      address_prefixes = ["10.0.1.0/24"]
    }

    aks = {
      name                   = "my-prod-aks"
      default_node_pool_name = "system"
      vm_size                = "Standard_DC2ads_v5"
      min_node_count         = 2
      max_node_count         = 5
      os_disk_size_gb        = 30
      os_disk_type           = "Managed"
      max_pods               = 50
      network_plugin         = "azure"
      network_policy         = "azure"
      load_balancer_sku      = "standard"
    }
  }
}
