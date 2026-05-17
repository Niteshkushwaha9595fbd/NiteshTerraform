variable "clusters" {
  description = "Nested map defining all AKS clusters with their networking and node pool config"
  type = map(object({
    location            = string
    resource_group_name = string
    kubernetes_version  = string
    dns_prefix          = string
    tags                = map(string)

    vnet = object({
      name          = string
      address_space = list(string)
    })

    subnet = object({
      name             = string
      address_prefixes = list(string)
    })

    aks = object({
      name                   = string
      default_node_pool_name = string
      vm_size                = string
      min_node_count         = number
      max_node_count         = number
      os_disk_size_gb        = number
      os_disk_type           = string
      max_pods               = number
      network_plugin         = string
      network_policy         = string
      load_balancer_sku      = string
      service_cidr           = string
      dns_service_ip         = string
      admin_group_object_ids = list(string)
    })
  }))
}
