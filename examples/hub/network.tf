locals {
  hub_vnet_name   = module.resource_names["hvnet"].minimal
  spoke_vnet_name = module.resource_names["svnet"].minimal
  nsg_name        = module.resource_names["nsg"].minimal_random_suffix
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

module "hub_vnet" {
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-virtual_network"

  address_space       = [var.hub_vnet_address_space]
  resource_group_name = module.resource_group.name
  vnet_location       = var.location
  vnet_name           = local.hub_vnet_name
  depends_on          = [module.resource_group, module.network_security_group]
}

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
module "inbound_dns_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.inbound_dns_subnet_address_space
  name                        = module.resource_names["ibsn"].standard
  network_security_group_id   = module.network_security_group.network_security_group_id
  network_security_group_name = local.nsg_name
  resource_group_name         = module.resource_group.name
  virtual_network_name        = local.hub_vnet_name
  delegations = {
    inbound_dns_resolver = {
      service_name    = "Microsoft.Network/dnsResolvers"
      service_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
  depends_on = [
    module.hub_vnet,
    module.network_security_group
  ]
}

module "outbound_dns_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.outbound_dns_subnet_address_space
  name                        = module.resource_names["obsn"].standard
  network_security_group_name = local.nsg_name
  network_security_group_id   = module.network_security_group.network_security_group_id
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

module "spoke_vnet" {
  source = "../../../../launchbynttdata/tf-azurerm-module_primitive-virtual_network"

  address_space       = [var.spoke_vnet_address_space]
  resource_group_name = module.resource_group.name
  vnet_location       = var.location
  vnet_name           = local.spoke_vnet_name
  depends_on          = [module.resource_group, module.network_security_group]
}

module "storage_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.storage_subnet_address_space
  name                        = module.resource_names["stsn"].standard
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
