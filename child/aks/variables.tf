# ── Core ──────────────────────────────────────────────────────────────────────

variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.30"
}

variable "automatic_upgrade_channel" {
  description = "Automatic upgrade channel: patch, rapid, node-image, stable, or none"
  type        = string
  default     = "patch"

  validation {
    condition     = contains(["patch", "rapid", "node-image", "stable", "none"], var.automatic_upgrade_channel)
    error_message = "Must be one of: patch, rapid, node-image, stable, none."
  }
}

variable "tenant_id" {
  description = "Azure AD tenant ID for RBAC integration"
  type        = string
}

# ── Node Pool ─────────────────────────────────────────────────────────────────

variable "default_node_pool_name" {
  description = "Name of the default (system) node pool"
  type        = string
  default     = "system"
}

variable "vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_D4s_v5"
}

variable "min_node_count" {
  description = "Minimum number of nodes (autoscaler)"
  type        = number
  default     = 2
}

variable "max_node_count" {
  description = "Maximum number of nodes (autoscaler)"
  type        = number
  default     = 5
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB for nodes"
  type        = number
  default     = 128
}

variable "os_disk_type" {
  description = "OS disk type: Managed or Ephemeral"
  type        = string
  default     = "Ephemeral"

  validation {
    condition     = contains(["Managed", "Ephemeral"], var.os_disk_type)
    error_message = "Must be Managed or Ephemeral."
  }
}

variable "max_pods" {
  description = "Maximum pods per node"
  type        = number
  default     = 50
}

variable "system_pool_only_critical_addons" {
  description = "Taint system node pool to only run critical addons (recommended for prod)"
  type        = bool
  default     = true
}

variable "node_pool_max_surge" {
  description = "Max surge nodes during upgrades (e.g. 33%)"
  type        = string
  default     = "33%"
}

variable "subnet_id" {
  description = "Subnet ID where AKS nodes will be deployed"
  type        = string
}

# ── Networking ────────────────────────────────────────────────────────────────

variable "network_plugin" {
  description = "Network plugin: azure or kubenet"
  type        = string
  default     = "azure"

  validation {
    condition     = contains(["azure", "kubenet"], var.network_plugin)
    error_message = "Must be azure or kubenet."
  }
}

variable "network_policy" {
  description = "Network policy: azure, calico, or cilium"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU: standard or basic"
  type        = string
  default     = "standard"
}

variable "outbound_type" {
  description = "Outbound routing: loadBalancer, userDefinedRouting, managedNATGateway, userAssignedNATGateway"
  type        = string
  default     = "loadBalancer"
}

variable "private_cluster_enabled" {
  description = "Enable private AKS cluster (API server not publicly accessible)"
  type        = bool
  default     = false
}

variable "authorized_ip_ranges" {
  description = "List of CIDR ranges authorized to access the API server (ignored when private_cluster_enabled = true)"
  type        = list(string)
  default     = []
}

# ── Observability ─────────────────────────────────────────────────────────────

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for OMS agent and Defender"
  type        = string
}

# ── Security ──────────────────────────────────────────────────────────────────

variable "secret_rotation_interval" {
  description = "Key Vault CSI driver secret rotation interval (e.g. 2m)"
  type        = string
  default     = "2m"
}

# ── Maintenance ───────────────────────────────────────────────────────────────

variable "maintenance_window_day" {
  description = "Day of week for maintenance window (e.g. Sunday)"
  type        = string
  default     = "Sunday"
}

variable "maintenance_window_hours" {
  description = "Hours (UTC) allowed for maintenance (0-23)"
  type        = list(number)
  default     = [1, 2, 3]
}

# ── Tags ──────────────────────────────────────────────────────────────────────

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
