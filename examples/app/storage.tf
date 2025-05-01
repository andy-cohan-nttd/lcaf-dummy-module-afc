locals {
  storage_account_name = module.resource_names["sa"].recommended_per_length_restriction
}

data "azurerm_subnet" "storage_subnet" {
  name                 = var.storage_subnet.subnet_name
  virtual_network_name = var.storage_subnet.vnet_name
  resource_group_name  = var.storage_subnet.resource_group
}

module "storage_account" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm"
  # version = "~> 1.3"
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-storage_account"

  enable_https_traffic_only     = true
  location                      = var.location
  public_network_access_enabled = false
  resource_group_name           = module.resource_group.name
  storage_account_name          = local.storage_account_name
  network_rules = {
    virtual_network_subnet_ids = [data.azurerm_subnet.storage_subnet.id]
  }
  depends_on = [module.resource_group]
}

# doesn't have the lifecycle ignore_changes we need since the policy modifies the endpoint
# module "storage_private_endpoint" {
#   source              = "../../../../launchbynttdata/tf-azurerm-module_primitive-private_endpoint"
#   location            = var.location
#   name                = module.resource_names["stpe"].standard
#   resource_group_name = module.resource_group.name
#   subnet_id           = data.azurerm_subnet.storage_subnet.id

#   private_service_connection = {
#     is_manual_connection           = false
#     name                           = "pe-${local.storage_account_name}"
#     private_connection_resource_id = module.storage_account.id
#     subresource_names              = ["blob"] # TODO
#   }
#   #   records             = [azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address]

#   depends_on = [module.resource_group]
# }

# so use a resource block for now until that module is updated
resource "azurerm_private_endpoint" "storage_pe" {
  name                = module.resource_names["stpe"].standard
  resource_group_name = module.resource_group.name
  location            = var.location
  subnet_id           = data.azurerm_subnet.storage_subnet.id

  private_service_connection {
    name                           = "pe-${local.storage_account_name}"
    is_manual_connection           = false
    private_connection_resource_id = module.storage_account.id
    subresource_names              = ["blob"]
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}
