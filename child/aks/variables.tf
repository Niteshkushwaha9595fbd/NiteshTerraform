variable "name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
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
  description = "Kubernetes version"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID for RBAC"
  type        = string
}

# ── Node Pool ─────────────────────────────────────────────────────────────────

variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "system"
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_D4s_v5"
}

variable "min_node_count" {
  description = "Minimum nodes (autoscaler)"
  type        = number
  default     = 2
}

variable "max_node_count" {
  description = "Maximum nodes (autoscaler)"
  type        = number
  default     = 5
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 128
}

variable "os_disk_type" {
  description = "OS disk type: Managed or Ephemeral"
  type        = string
  default     = "Managed"
}

variable "max_pods" {
  description = "Maximum pods per node"
  type        = number
  default     = 50
}

variable "subnet_id" {
  description = "Subnet ID for AKS nodes"
  type        = string
}

# ── Networking ────────────────────────────────────────────────────────────────

variable "network_plugin" {
  description = "Network plugin: azure or kubenet"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy: azure or calico"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU"
  type        = string
  default     = "standard"
}

# ── Tags ──────────────────────────────────────────────────────────────────────

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
