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

# variable "function_app_display_name" {
#   description = "The display_name of the Azure Function App"
#   type        = string
#   default     = "test-function-app"
# }

# variable "function_app_sku_name" {
#   description = "The SKU name for the Azure Function App"
#   type        = string
#   default     = "Y1"
# }
#
# variable "fa_storage_account" {
#   description = "Attributes for the storage account used by the function app"
#   type = object({
#     tier             = string
#     replication_type = string
#   })
#   default = {
#     tier             = "Standard"
#     replication_type = "LRS"
#   }
# }

# variable "management_group" {
#   description = "Azure Management Group where the policy assignment will be created."
#   type = object({
#     id   = string
#     name = string
#   })
# }

# variable "policy_name" {
#   type        = string
#   description = "The name of the policy definition."
# }

# variable "policy_display_name" {
#   type        = string
#   description = "The name of the policy definition."
# }

# variable "policy_type" {
#   description = "The type of the policy definition. Can be 'Custom', 'BuiltIn', 'NotSpecified' or 'Static'."
#   type        = string
#   default     = "Custom"
#   validation {
#     condition     = contains(["Custom", "BuiltIn", "NotSpecified", "Static"], var.policy_type)
#     error_message = "The policy_type must be one of 'Custom', 'BuiltIn', 'NotSpecified' or 'Static'."
#   }
# }

# variable "policy_mode" {
#   description = "The mode of the policy definition"
#   type        = string
#   default     = "Indexed"
#   validation {
#     condition = contains([
#       "All",
#       "Indexed",
#       "Microsoft.ContainerService.Data",
#       "Microsoft.CustomerLockbox.Data",
#       "Microsoft.DataCatalog.Data",
#       "Microsoft.KeyVault.Data",
#       "Microsoft.Kubernetes.Data",
#       "Microsoft.MachineLearningServices.Data",
#       "Microsoft.Network.Data and Microsoft.Synapse.Data"
#     ], var.policy_mode)
#     error_message = "The policy_mode must be either 'Indexed' or 'All'."
#   }
# }

variable "private_dns_zones" {
  description = "The names of the private DNS zones to be monitored."
  type        = set(string)
  default     = []
}
