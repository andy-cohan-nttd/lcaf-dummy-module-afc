resource "azurerm_private_dns_zone" "dns_zone" {
  for_each = toset(local.azure_private_zones)

  name                = "privatelink.${each.value}"
  resource_group_name = module.resource_group.name
  depends_on          = [module.resource_group]
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link" {
  for_each = toset(local.azure_private_zones)

  name                  = module.resource_names["pdzvnl"].minimal_random_suffix # "privatelink.${each.value}"
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = "privatelink.${each.value}"
  virtual_network_id    = module.hub_vnet.vnet_id
  depends_on            = [azurerm_private_dns_zone.dns_zone]
}

module "private_dns_resolver" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/private_dns_resolver/azurerm"
  # version = "~> 1.0"
  source = "../../../tf-azurerm-module_collection-private_dns_resolver"

  location               = var.location
  name                   = module.resource_names["pdnsr"].standard
  inbound_endpoint_name  = module.resource_names["pdnsriep"].standard
  outbound_endpoint_name = module.resource_names["pdnsroep"].standard
  resolver_link_name     = module.resource_names["pdnsrvnl"].standard
  resource_group_name    = module.resource_group.name
  ruleset_name           = module.resource_names["pdnsrfr"].standard
  inbound_subnet_id      = module.inbound_dns_subnet.id
  outbound_subnet_id     = module.outbound_dns_subnet.id
  tags                   = var.tags
  virtual_network_id     = module.hub_vnet.vnet_id
}

resource "azurerm_virtual_network_dns_servers" "hub_vnet_dns_servers" {
  virtual_network_id = module.hub_vnet.vnet_id
  dns_servers        = [module.private_dns_resolver.private_dns_resolver_ip]
}

resource "azurerm_virtual_network_dns_servers" "spoke_vnet_dns_servers" {
  virtual_network_id = module.spoke_vnet.vnet_id
  dns_servers        = [module.private_dns_resolver.private_dns_resolver_ip]
}
