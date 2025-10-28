variable "rgs" {
  description = "Map of resource groups with name and location"
  type = map(object({
    rg_name     = string
    rg_location = string
  }))
}
variable "Aks" {
  description = "Map of AKS cluster configurations."
  type = map(object({
    aks_name   = string
    dns_prefix = string
  }))
}
