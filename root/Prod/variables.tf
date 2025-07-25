variable "rgs" {
  description = "Map of resource groups with name and location"
  type = map(object({
    rg_name     = string
    rg_location = string
  }))
}

variable "aks_rs" {
  description = "Map of AKS clusters with their names"
  type = map(object({
    aks_name = string
  }))
}

# variable "rg_name" {
#   description = "Name of the existing resource group"
#   type        = string
# }