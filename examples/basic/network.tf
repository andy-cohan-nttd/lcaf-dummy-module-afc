module "vnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.0"

  resource_group_name = module.resource_group.name
  vnet_name           = module.resource_names["vnet"].minimal_random_suffix
  vnet_location       = var.location
  address_space       = [var.vnet_address_prefix]
}

locals {
  nsg_name         = module.resource_names["nsg"].minimal_random_suffix
  route_table_name = module.resource_names["rt"].minimal_random_suffix
}

module "network_security_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/network_security_group/azurerm"
  version = "~> 1.0"

  location            = var.location
  name                = local.nsg_name
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "route_table" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/route_table/azurerm"
  version = "~> 1.0"

  location            = var.location
  name                = local.route_table_name
  resource_group_name = module.resource_group.name
}

module "outbound_dns_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.outbound_dns_subnet_address_prefix
  name                        = module.resource_names["sn"].standard
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

resource "azurerm_private_dns_resolver" "test" {
  location            = var.location
  name                = module.resource_names["pdnsr"].standard
  resource_group_name = module.resource_group.name
  virtual_network_id  = module.vnet.vnet_id
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "test_ob" {
  location                = azurerm_private_dns_resolver.test.location
  name                    = module.resource_names["pdnsroep"].standard
  private_dns_resolver_id = azurerm_private_dns_resolver.test.id
  subnet_id               = module.outbound_dns_subnet.subnet.id
  tags                    = var.tags
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "ruleset1" {
  name                = module.resource_names["pdnsrfr"].standard
  resource_group_name = module.resource_group.name
  location            = var.location
  private_dns_resolver_outbound_endpoint_ids = [
    azurerm_private_dns_resolver_outbound_endpoint.test_ob.id
  ]
  tags = var.tags
}

resource "azurerm_private_dns_resolver_virtual_network_link" "vnet_link" {
  name                      = module.resource_names["pdnsrvnl"].standard
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset1.id
  virtual_network_id        = module.vnet.vnet_id
  # metadata = {
  #   key = "value"
  # }
}
