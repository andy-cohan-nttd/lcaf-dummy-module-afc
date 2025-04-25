module "resource_names" {
  # source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  # version = "~> 2.1"
  source = "../../../../launchbynttdata/tf-launch-module_library-resource_name"

  for_each = local.resource_names

  logical_product_family  = var.product_family
  logical_product_service = "test"
  region                  = var.location
  class_env               = var.environment
  cloud_resource_type     = each.value
  maximum_length          = 32
}

module "short_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.1"

  for_each = toset(["sa", "polsa", "poldns", "polga"])

  logical_product_family  = var.product_family
  logical_product_service = "test"
  region                  = var.location
  class_env               = var.environment
  cloud_resource_type     = each.value
  maximum_length          = 20
}


module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = module.resource_names["rg"].standard
  location = var.location
  tags     = var.tags
}

# data "azurerm_client_config" "current" {
#   # This data source is used to get the current Azure client configuration
# }

module "management_group" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/management_group/azurerm"
  # version = "~> 1.0"
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-management_group" # Use the local path for testing

  name             = module.resource_names["mgmtgrp"].standard
  display_name     = "Management Group for PDNS Policy"
  subscription_ids = [] # [data.azurerm_client_config.current.subscription_id] # Use the current subscription for the management group
}
