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
  source              = "../../child/aks"
  aks_name            = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  vm_size             = var.vm_size
  subnet_id           = module.subnet.subnet_id
  network_plugin      = var.network_plugin
  load_balancer_sku   = var.load_balancer_sku
  tags                = var.tags
  depends_on          = [module.subnet]
}
