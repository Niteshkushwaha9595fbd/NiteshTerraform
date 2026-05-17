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

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for OMS agent and Defender"
  type        = string
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_DS2_v2"
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
