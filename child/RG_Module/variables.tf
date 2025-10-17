variable "rgs" {
  description = "Map of resource groups with name and location"
  type = map(object({
    rg_name     = string
    rg_location = string
  }))
}