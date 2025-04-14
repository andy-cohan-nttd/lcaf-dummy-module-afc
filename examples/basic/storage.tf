module "sa_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.1"

  for_each = toset(["sa"])

  logical_product_family  = local.product_family
  logical_product_service = "test"
  region                  = var.location
  class_env               = var.environment
  cloud_resource_type     = each.value
  maximum_length          = 24
}

module "storage_account" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm"
  # version = "~> 1.3"
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-storage_account"

  enable_https_traffic_only     = true
  location                      = var.location
  public_network_access_enabled = false
  resource_group_name           = module.resource_group.name
  storage_account_name          = module.sa_names["sa"].recommended_per_length_restriction
  network_rules = {
    virtual_network_subnet_ids = [module.storage_subnet.id]
    # private_link_access = [
    #   {
    #     endpoint_resource_id = "TODO"
    #   }
    # ]
  }
  depends_on = [module.resource_group]
}

module "storage_private_endpoint" {
  source              = "../../../../launchbynttdata/tf-azurerm-module_primitive-private_endpoint"
  location            = var.location
  name                = "storage-pe" # TODO
  resource_group_name = module.resource_group.name
  subnet_id           = module.storage_subnet.id

  private_service_connection = {
    is_manual_connection           = false
    name                           = "storage-pe-psc" # TODO
    private_connection_resource_id = module.storage_account.id
    subresource_names              = ["blob"] # TODO
  }
  #   records             = [azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address]

  depends_on = [module.resource_group]
}
