locals {
  vnet_name = module.resource_names["vnet"].minimal_random_suffix
}

module "vnet" {
  source              = "../../../../launchbynttdata/tf-azurerm-module_primitive-virtual_network"
  resource_group_name = module.resource_group.name
  vnet_name           = local.vnet_name
  vnet_location       = var.location
  address_space       = [var.vnet_address_space]
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

module "nsg_association" {
  source                    = "terraform.registry.launch.nttdata.com/module_primitive/nsg_subnet_association/azurerm"
  version                   = "~> 1.0"
  subnet_id                 = module.outbound_dns_subnet.subnet.id
  network_security_group_id = module.network_security_group.network_security_group_id
  depends_on                = [module.resource_group]
}

module "route_table" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/route_table/azurerm"
  version = "~> 1.0"

  location            = var.location
  name                = local.route_table_name
  resource_group_name = module.resource_group.name
}

# module "rttbl_subnet_association" {
#   source  = "terraform.registry.launch.nttdata.com/module_primitive/tf-azurerm-module_primitive-routetable_subnet_association/azurerm"
#   version = "~> 1.0"

#   route_table_id = module.route_table.id
#   subnet_id      = module.outbound_dns_subnet.subnet.id
# }

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
    #     module.network_security_group,
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
  virtual_network_id     = module.vnet.vnet_id
}

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
