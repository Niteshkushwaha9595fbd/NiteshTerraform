module "vnet" {
  source              = "../../child/vnet"
  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

module "subnet" {
  source              = "../../child/subnet"
  subnet_name         = var.subnet_name
  resource_group_name = var.resource_group_name
  vnet_name           = module.vnet.vnet_name
  address_prefixes    = var.address_prefixes
  depends_on          = [module.vnet]
}

module "aks" {
  source                          = "../../child/aks"
  aks_name                        = var.aks_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  dns_prefix                      = var.dns_prefix
  kubernetes_version              = var.kubernetes_version
  tenant_id                       = var.tenant_id

  # Node Pool
  default_node_pool_name          = var.default_node_pool_name
  vm_size                         = var.vm_size
  min_node_count                  = var.min_node_count
  max_node_count                  = var.max_node_count
  os_disk_size_gb                 = var.os_disk_size_gb
  os_disk_type                    = var.os_disk_type
  max_pods                        = var.max_pods
  system_pool_only_critical_addons = var.system_pool_only_critical_addons
  node_pool_max_surge             = var.node_pool_max_surge
  subnet_id                       = module.subnet.subnet_id

  # Networking
  network_plugin                  = var.network_plugin
  load_balancer_sku               = var.load_balancer_sku

  tags                            = var.tags
  depends_on                      = [module.subnet]
}
