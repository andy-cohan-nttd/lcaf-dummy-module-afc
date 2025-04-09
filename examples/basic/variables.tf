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

variable "parent_management_group_id" {
  description = "The ID of the parent management group for creating the management group. Leave empty for root."
  type        = string
  default     = ""
}

variable "subscription_ids" {
  description = "List of subscription IDs to associate with the management group."
  type        = list(string)
  default     = []
}

variable "vnet_address_space" {
  description = "The address prefix for the virtual network. Use slash notation"
  type        = string
  default     = "10.53.0.0/16" # Default value for the virtual network address prefix, can be overridden
}

variable "outbound_dns_subnet_address_prefix" {
  description = "The address prefix for the outbound DNS subnet. Use slash notation"
  type        = string
  default     = "10.53.0.0/26"
}

variable "storage_subnet_address_prefix" {
  description = "The address prefix for the storage subnet. Use slash notation"
  type        = string
  default     = "10.53.0.64/26"
}

variable "function_app_display_name" {
  description = "The display_name of the Azure Function App"
  type        = string
  default     = "test-function-app"
}

variable "function_app_sku_name" {
  description = "The SKU name for the Azure Function App"
  type        = string
  default     = "Y1"
}
variable "fa_storage_account" {
  description = "Attributes for the storage account used by the function app"
  type = object({
    tier             = string
    replication_type = string
  })
  default = {
    tier             = "Standard"
    replication_type = "LRS"
  }
}
