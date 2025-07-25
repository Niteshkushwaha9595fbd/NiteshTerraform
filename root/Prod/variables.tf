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

variable "log_analytic" {
  description = "Map of Log Analytics workspaces with their names and other optional settings"
  type = map(object({
    l_name = string
  }))
}