variable "aks_rs" {
  description = "Map of AKS clusters with their names"
  type = map(object({
    aks_name = string
  }))
}



