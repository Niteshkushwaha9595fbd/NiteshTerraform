resource_group_name = "my-prod-rg"
location            = "East US"

vnet_name     = "my-prod-vnet"
address_space = ["10.0.0.0/16"]

subnet_name      = "my-aks-subnet"
address_prefixes = ["10.0.1.0/24"]

aks_name                   = "my-prod-aks"
dns_prefix                 = "myprodaks"
kubernetes_version         = "1.29.0"
# Node Pool
default_node_pool_name          = "system"
vm_size                         = "Standard_DS2_v2"
min_node_count                  = 1
max_node_count                  = 2
os_disk_size_gb                 = 128
os_disk_type                    = "Managed"
max_pods                        = 50
system_pool_only_critical_addons = true
node_pool_max_surge             = "33%"

# Networking
network_plugin             = "azure"
load_balancer_sku          = "standard"
tenant_id                  = "f9934c5a-955e-44d3-b114-0bafd54fd8b9"

tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
}
