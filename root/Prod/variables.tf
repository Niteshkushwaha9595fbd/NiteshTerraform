# Resource Group
variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

# VNet
variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Address space for VNet"
  type        = list(string)
}

# Subnet
variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}

variable "address_prefixes" {
  description = "Address prefixes for Subnet"
  type        = list(string)
}

# AKS
variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for AKS"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29.0"
}

variable "tenant_id" {
  description = "Azure AD tenant ID for RBAC integration"
  type        = string
}

# Node Pool
variable "default_node_pool_name" {
  description = "Name of the default (system) node pool"
  type        = string
  default     = "system"
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_DS2_v2"
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
}

variable "max_pods" {
  description = "Maximum pods per node"
  type        = number
  default     = 50
}

variable "system_pool_only_critical_addons" {
  description = "Taint system node pool to only run critical addons"
  type        = bool
  default     = true
}

variable "node_pool_max_surge" {
  description = "Max surge nodes during upgrades (e.g. 33%)"
  type        = string
  default     = "33%"
}

variable "network_plugin" {
  description = "Network plugin (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU"
  type        = string
  default     = "standard"
}

# Common
variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}
