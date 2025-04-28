variable "environment" {
  description = "Environment name e.g. sandbox"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created. This should be a valid Azure region."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "product_family" {
  description = "The product family for the resources, used for naming conventions."
  type        = string
}

variable "spoke_vnet_address_space" {
  description = "The address prefix for the spoke network. Use slash notation"
  type        = string
  default     = "10.55.0.0/16" # Default value for the virtual network address prefix, can be overridden
}

variable "storage_subnet_address_space" {
  description = "The address prefix for the storage subnet. Use slash notation"
  type        = string
  default     = "10.55.0.0/26"
}

variable "private_dns_resolver_ip" {
  description = "The IP address of the private DNS resolver"
  type        = string
}

variable "hub_vnet" {
  type = object({
    name           = string
    resource_group = string
  })
  description = "coordinates of the hub virtual network"
}
