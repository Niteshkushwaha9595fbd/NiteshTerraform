variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the VNet this subnet belongs to"
  type        = string
}

variable "address_prefixes" {
  description = "Address prefixes for the subnet (CIDR)"
  type        = list(string)
}
