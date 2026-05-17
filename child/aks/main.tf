resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  # Private cluster
  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = false

  # API server access
  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  # Automatic upgrade channel
  automatic_upgrade_channel = var.automatic_upgrade_channel

  # OIDC + Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name                         = var.default_node_pool_name
    vm_size                      = var.vm_size
    vnet_subnet_id               = var.subnet_id
    os_disk_size_gb              = var.os_disk_size_gb
    os_disk_type                 = var.os_disk_type
    max_pods                     = var.max_pods
    only_critical_addons_enabled = var.system_pool_only_critical_addons

    # Auto-scaling
    auto_scaling_enabled = true
    min_count            = var.min_node_count
    max_count            = var.max_node_count

    upgrade_settings {
      max_surge = var.node_pool_max_surge
    }

    tags = var.tags
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    load_balancer_sku = var.load_balancer_sku
    outbound_type     = var.outbound_type
  }

  # Azure AD RBAC
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = var.tenant_id
  }

  # Maintenance window
  maintenance_window {
    allowed {
      day   = var.maintenance_window_day
      hours = var.maintenance_window_hours
    }
  }

  # Azure Monitor
  monitor_metrics {}

  oms_agent {
    log_analytics_workspace_id      = var.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  # Microsoft Defender
  microsoft_defender {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  # Key Vault CSI driver
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = var.secret_rotation_interval
  }

  # Disable legacy HTTP routing
  http_application_routing_enabled = false

  tags = var.tags

  lifecycle {
    ignore_changes = [
      # Ignore node count changes managed by cluster autoscaler
      default_node_pool[0].node_count,
      kubernetes_version,
    ]
  }
}
