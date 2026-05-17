# ── Resource Groups ────────────────────────────────────────────────────────────

module "rg" {
  source   = "../../child/rg"
  for_each = var.clusters

  name     = each.value.resource_group_name
  location = each.value.location
  tags     = each.value.tags
}

# ── Virtual Networks ──────────────────────────────────────────────────────────

module "vnet" {
  source   = "../../child/vnet"
  for_each = var.clusters

  name                = each.value.vnet.name
  location            = each.value.location
  resource_group_name = module.rg[each.key].name
  address_space       = each.value.vnet.address_space
  tags                = each.value.tags

  depends_on = [module.rg]
}

# ── Subnets ───────────────────────────────────────────────────────────────────

module "subnet" {
  source   = "../../child/subnet"
  for_each = var.clusters

  name                 = each.value.subnet.name
  resource_group_name  = module.rg[each.key].name
  virtual_network_name = module.vnet[each.key].name
  address_prefixes     = each.value.subnet.address_prefixes

  depends_on = [module.vnet]
}

# ── AKS Clusters ─────────────────────────────────────────────────────────────

module "aks" {
  source   = "../../child/aks"
  for_each = var.clusters

  name                   = each.value.aks.name
  location               = each.value.location
  resource_group_name    = module.rg[each.key].name
  dns_prefix             = each.value.dns_prefix
  kubernetes_version     = each.value.kubernetes_version
  tenant_id              = each.value.tenant_id

  # Node Pool
  default_node_pool_name = each.value.aks.default_node_pool_name
  vm_size                = each.value.aks.vm_size
  min_node_count         = each.value.aks.min_node_count
  max_node_count         = each.value.aks.max_node_count
  os_disk_size_gb        = each.value.aks.os_disk_size_gb
  os_disk_type           = each.value.aks.os_disk_type
  max_pods               = each.value.aks.max_pods
  subnet_id              = module.subnet[each.key].id

  # Networking
  network_plugin    = each.value.aks.network_plugin
  network_policy    = each.value.aks.network_policy
  load_balancer_sku = each.value.aks.load_balancer_sku

  tags = each.value.tags

  depends_on = [module.subnet]
}
