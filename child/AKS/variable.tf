variable "Aks" {
  description = "Map of AKS cluster configurations."
  type = map(object({
    aks_name   = string
    dns_prefix = string
  }))
}


