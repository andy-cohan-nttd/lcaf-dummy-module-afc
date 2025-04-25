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

# variable "parent_management_group_id" {
#   description = "The ID of the parent management group for creating the management group. Leave empty for root."
#   type        = string
#   default     = ""
# }

# variable "subscription_ids" {
#   description = "List of subscription IDs to associate with the management group."
#   type        = list(string)
#   default     = []
# }

variable "hub_vnet_address_space" {
  description = "The address prefix for the hub network. Use slash notation"
  type        = string
  default     = "10.53.0.0/16" # Default value for the virtual network address prefix, can be overridden
}

variable "resolver_vnet_address_space" {
  description = "The address prefix for the DNS resolver network. Use slash notation"
  type        = string
  default     = "10.54.0.0/16" # Default value for the virtual network address prefix, can be overridden
}

variable "inbound_dns_subnet_address_space" {
  description = "The address prefix for the inbound DNS subnet. Use slash notation"
  type        = string
  default     = "10.54.0.0/26"
}

variable "outbound_dns_subnet_address_space" {
  description = "The address prefix for the outbound DNS subnet. Use slash notation"
  type        = string
  default     = "10.54.0.64/26"
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
