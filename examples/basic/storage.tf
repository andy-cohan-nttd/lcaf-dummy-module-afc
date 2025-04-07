module "storage_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.storage_subnet_address_prefix
  name                        = module.resource_names["sn"].minimal_random_suffix
  network_security_group_name = local.nsg_name
  # private_endpoint_network_policies =
  # private_link_service_network_policies_enabled = true
  resource_group_name  = module.resource_group.name
  route_table_name     = local.route_table_name
  service_endpoints    = [] # TODO
  virtual_network_name = module.vnet.vnet_name
  # delegations {
  #   name = "Microsoft.Network.dnsResolvers"
  #   service_delegation {
  #     actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
  #     name    = "Microsoft.Network/dnsResolvers"
  #   }
  # }

  depends_on = [
    module.vnet,
    module.network_security_group,
    module.route_table,
  ]
}
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
  source  = "terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm"
  version = "~> 1.3"

  location                      = var.location
  public_network_access_enabled = false
  resource_group_name           = module.resource_group.name
  storage_account_name          = module.sa_names["sa"].recommended_per_length_restriction

  # account_tier              = var.account_tier
  # account_replication_type  = var.account_replication_type
  # storage_containers        = var.storage_containers
  # storage_shares            = var.storage_shares
  # storage_queues            = var.storage_queues
  # static_website            = var.static_website
  enable_https_traffic_only = true
  # access_tier               = var.access_tier
  # account_kind              = var.account_kind

  # blob_cors_rule                         = var.blob_cors_rule
  # blob_delete_retention_policy           = var.blob_delete_retention_policy
  # blob_versioning_enabled                = var.blob_versioning_enabled
  # blob_change_feed_enabled               = var.blob_change_feed_enabled
  # blob_last_access_time_enabled          = var.blob_last_access_time_enabled
  # blob_container_delete_retention_policy = var.blob_container_delete_retention_policy
  network_rules = {
    virtual_network_subnet_id = module.storage_subnet.id
    # default_action             = optional(string, "Deny")
    # bypass                     = optional(list(string), ["AzureServices", "Logging", "Metrics"])
    # ip_rules                   = optional(list(string), [])
    # virtual_network_subnet_ids = optional(list(string), [])
    # private_link_access = optional(list(object({
    #   endpoint_resource_id = string
    #   endpoint_tenant_id   = optional(string, null)
    # })), [])
  }

  depends_on = [module.resource_group]
}
