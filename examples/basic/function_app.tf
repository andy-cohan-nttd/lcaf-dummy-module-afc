# resource "azurerm_private_dns_zone" "dns_zone" {
#   name                = "privatelink.azurewebsites.net"
#   resource_group_name = module.resource_group.name

#   depends_on = [module.resource_group]
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
#   name                  = "vnetlink"
#   resource_group_name   = module.resource_group.name
#   private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
#   virtual_network_id    = module.virtual_network.vnet_id

#   depends_on = [module.resource_group]
# }

# resource "azurerm_private_dns_a_record" "dns_a_record" {
#   name                = module.function_app.function_app_name
#   records             = [azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address]
#   resource_group_name = module.resource_group.name
#   ttl                 = 300
#   zone_name           = azurerm_private_dns_zone.dns_zone.name

#   depends_on = [module.resource_group]
# }

# locals {
#   service_plan_name    = module.resource_names["sp"].standard
#   storage_account_name = module.resource_names["sa"].dns_compliant_minimal_random_suffix
# }

# module "fa_storage_account" {
#   source  = "terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm"
#   version = "~> 1.0"

#   storage_account_name = local.storage_account_name
#   resource_group_name  = module.resource_group.name

#   location = var.location

#   account_tier             = var.fa_storage_account.tier
#   account_replication_type = var.fa_storage_account.replication_type

#   tags = merge(var.tags, { resource_name = local.storage_account_name })

#   depends_on = [module.resource_group]
# }

# module "app_service_plan" {
#   # source  = "terraform.registry.launch.nttdata.com/module_primitive/app_service_plan/azurerm"
#   # version = "~> 1.0"
#   source = "../../../../launchbynttdata/tf-azurerm-module_primitive-app_service_plan"

#   name                = local.service_plan_name
#   resource_group_name = module.resource_group.name

#   os_type = "Linux"

#   location = var.location
#   sku_name = var.function_app_sku_name

#   tags = merge(var.tags, { resource_name = module.resource_names["sp"].standard })

#   depends_on = [module.resource_group]
# }

# module "function_app" {
#   source = "../../../../andy-cohan-nttd/tf-azurerm-module_primitive-linux_function_app"

#   name                = module.resource_names["fa"].dns_compliant_minimal_random_suffix
#   identity_name       = module.resource_names["fa"].dns_compliant_minimal_random_suffix
#   location            = var.location
#   resource_group_name = module.resource_group.name
#   service_plan_id     = module.app_service_plan.id
#   storage_account = {
#     name       = local.storage_account_name
#     access_key = module.fa_storage_account.primary_access_key
#   }

#   depends_on = [module.resource_group, module.fa_storage_account, module.app_service_plan]
# }

# module "role_assignment" {
#   # source  = "terraform.registry.launch.nttdata.com/module_primitive/role_assignment/azurerm"
#   # version = "~> 1.0"
#   source = "../../../../launchbynttdata/tf-azurerm-module_primitive-role_assignment"

#   scope                = module.fa_storage_account.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = module.function_app.principal_id
#   depends_on           = [module.function_app]
# }
