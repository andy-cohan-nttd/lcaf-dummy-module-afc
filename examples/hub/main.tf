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

  for_each = toset(["sa", "pol"])

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

data "azurerm_client_config" "current" {
  # This data source is used to get the current Azure client configuration
}

module "management_group" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/management_group/azurerm"
  # version = "~> 1.0"
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-management_group" # Use the local path for testing

  name             = module.resource_names["mgmtgrp"].standard
  display_name     = "Management Group for PDNS Policy"
  subscription_ids = [] # [data.azurerm_client_config.current.subscription_id] # Use the current subscription for the management group
}

# module "private_dns_policy" {
#   source = "../../"

#   management_group    = module.management_group.management_group
#   policy_name         = module.sa_names["pol"].minimal_random_suffix
#   policy_display_name = "Private Endpoint DNS Policy"
#   # subnetId = module.outbound_dns_subnet.subnet.id
#   # private_dns_zones = toset(tolist(azurerm_private_dns_zone.dns_zone[*].name))
#   private_dns_zones        = toset(local.azure_private_zones)
#   deployment_identity_name = module.resource_names["deployer"].minimal_random_suffix
#   resource_group_name      = module.resource_group.name
#   location                 = var.location
# }
