locals {
  hub_vnet_name   = module.resource_names["vneth"].minimal_random_suffix
  spoke_vnet_name = module.resource_names["vnets"].minimal_random_suffix
}

module "hub_vnet" {
  source              = "../../../../launchbynttdata/tf-azurerm-module_primitive-virtual_network"
  resource_group_name = module.resource_group.name
  vnet_name           = local.hub_vnet_name
  vnet_location       = var.location
  address_space       = [var.hub_vnet_address_space]
  depends_on          = [module.resource_group]
}

locals {
  nsg_name = module.resource_names["nsg"].minimal_random_suffix
  # route_table_name = module.resource_names["rt"].minimal_random_suffix
}

module "network_security_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/network_security_group/azurerm"
  version = "~> 1.0"

  location            = var.location
  name                = local.nsg_name
  resource_group_name = module.resource_group.name
  tags                = var.tags

  # HTTP
  security_rules = [
    {
      name                       = "AllowFunctionAppAccess"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    # HTTPS
    {
      name                       = "AllowHTTPS"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    # DNS
    {
      name                       = "AllowDNS"
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  depends_on = [module.resource_group]
}

# module "nsg_association" {
#   # source                    = "terraform.registry.launch.nttdata.com/module_primitive/nsg_subnet_association/azurerm"
#   # version                   = "~> 1.0"
#   source                    = "../../../../launchbynttdata/tf-azurerm-module_primitive-nsg_subnet_association"
#   subnet_id                 = module.outbound_dns_subnet.subnet.id
#   network_security_group_id = module.network_security_group.network_security_group_id
#   depends_on                = [module.resource_group]
# }

# module "route_table" {
#   source  = "terraform.registry.launch.nttdata.com/module_primitive/route_table/azurerm"
#   version = "~> 1.0"

#   location            = var.location
#   name                = local.route_table_name
#   resource_group_name = module.resource_group.name
# }

# module "rttbl_subnet_association" {
#   source  = "terraform.registry.launch.nttdata.com/module_primitive/tf-azurerm-module_primitive-routetable_subnet_association/azurerm"
#   version = "~> 1.0"

#   route_table_id = module.route_table.id
#   subnet_id      = module.outbound_dns_subnet.subnet.id
# }

module "outbound_dns_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.outbound_dns_subnet_address_space
  name                        = module.resource_names["sn"].standard
  network_security_group_name = local.nsg_name
  resource_group_name         = module.resource_group.name
  virtual_network_name        = local.hub_vnet_name
  delegations = {
    outbound_dns_resolver = {
      service_name    = "Microsoft.Network/dnsResolvers"
      service_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

  depends_on = [
    module.hub_vnet,
    module.network_security_group,
    #     module.route_table,
  ]
}

module "private_dns_resolver" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/private_dns_resolver/azurerm"
  # version = "~> 1.0"
  source = "../../../tf-azurerm-module_primitive-private_dns_resolver"

  location               = var.location
  name                   = module.resource_names["pdnsr"].standard
  outbound_endpoint_name = module.resource_names["pdnsroep"].standard
  resolver_link_name     = module.resource_names["pdnsrvnl"].standard
  resource_group_name    = module.resource_group.name
  ruleset_name           = module.resource_names["pdnsrfr"].standard
  subnet_id              = module.outbound_dns_subnet.id
  tags                   = var.tags
  virtual_network_id     = module.hub_vnet.vnet_id
}

module "spoke_vnet" {
  source              = "../../../../launchbynttdata/tf-azurerm-module_primitive-virtual_network"
  resource_group_name = module.resource_group.name
  vnet_name           = local.spoke_vnet_name
  vnet_location       = var.location
  address_space       = [var.spoke_vnet_address_space]
  depends_on          = [module.resource_group]
}

module "storage_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.storage_subnet_address_space
  name                        = module.resource_names["sn"].minimal_random_suffix
  network_security_group_name = local.nsg_name
  resource_group_name         = module.resource_group.name
  service_endpoints           = ["Microsoft.Storage"]
  virtual_network_name        = local.spoke_vnet_name

  depends_on = [
    module.spoke_vnet,
    module.network_security_group,
    # module.route_table,
  ]
}

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

module "peer_hub_vnet_to_spoke_vnet" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/vnet_peering/azurerm"
  # version = "~> 1.0"
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-vnet_peering"

  peering_name                 = "peer${local.hub_vnet_name}_to_${local.spoke_vnet_name}"
  resource_group_name          = module.resource_group.name
  virtual_network_name         = local.hub_vnet_name
  remote_virtual_network_id    = module.spoke_vnet.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [module.hub_vnet, module.spoke_vnet]
}

module "peer_spoke_vnet_to_hub_vnet" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/vnet_peering/azurerm"
  # version = "~> 1.0"
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-vnet_peering"

  peering_name                 = "peer${local.spoke_vnet_name}_to_${local.hub_vnet_name}"
  resource_group_name          = module.resource_group.name
  virtual_network_name         = local.spoke_vnet_name
  remote_virtual_network_id    = module.hub_vnet.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [module.hub_vnet, module.spoke_vnet]
}
