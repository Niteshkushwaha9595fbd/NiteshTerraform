resource_group_name = "my-prod-rg"
location            = "East US"

vnet_name     = "my-prod-vnet"
address_space = ["10.0.0.0/16"]

subnet_name      = "my-aks-subnet"
address_prefixes = ["10.0.1.0/24"]

aks_name                   = "my-prod-aks"
dns_prefix                 = "myprodaks"
kubernetes_version         = "1.29.0"
vm_size                    = "Standard_DS2_v2"
network_plugin             = "azure"
load_balancer_sku          = "standard"
tenant_id                  = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
log_analytics_workspace_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-prod-rg/providers/Microsoft.OperationalInsights/workspaces/my-prod-law"

tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
}
