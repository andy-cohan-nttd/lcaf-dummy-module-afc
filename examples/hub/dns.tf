resource "azurerm_private_dns_zone" "dns_zone" {
  for_each = toset(local.azure_private_zones)

  name                = each.value
  resource_group_name = module.resource_group.name
  depends_on          = [module.resource_group]
}

resource "azurerm_private_dns_zone" "privatelink_dns_zone" {
  for_each = toset(local.azure_private_zones)

  name                = "privatelink.${each.value}"
  resource_group_name = module.resource_group.name
  depends_on          = [module.resource_group]
}

# link hub vnet to private dns zones
resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  for_each = toset(local.azure_private_zones)

  name                  = module.resource_names["pdzvnl"].minimal_random_suffix
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = each.value
  virtual_network_id    = module.hub_vnet.vnet_id
  depends_on            = [azurerm_private_dns_zone.dns_zone]
}

# link hub vnet to private dns zones
resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_dns_vnet_link" {
  for_each = toset(local.azure_private_zones)

  name                  = module.resource_names["pdzvnp"].minimal_random_suffix
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = "privatelink.${each.value}"
  virtual_network_id    = module.hub_vnet.vnet_id
  depends_on            = [azurerm_private_dns_zone.privatelink_dns_zone]
}
