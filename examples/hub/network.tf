// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

locals {
  hub_vnet_name      = module.resource_names["hvnet"].recommended_per_length_restriction
  resolver_vnet_name = module.resource_names["rvnet"].recommended_per_length_restriction
  nsg_name           = module.resource_names["nsg"].minimal_random_suffix
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

module "dns_resolver_vnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.1"

  address_space       = [var.resolver_vnet_address_space]
  resource_group_name = module.resource_group.name
  vnet_location       = var.location
  vnet_name           = local.resolver_vnet_name
  depends_on          = [module.resource_group, module.network_security_group]
}

module "inbound_dns_subnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm"
  version = "~> 1.1"

  address_prefix              = var.inbound_dns_subnet_address_space
  name                        = module.resource_names["ibsn"].standard
  network_security_group_id   = module.network_security_group.network_security_group_id
  network_security_group_name = local.nsg_name
  resource_group_name         = module.resource_group.name
  virtual_network_name        = local.resolver_vnet_name
  delegations = {
    inbound_dns_resolver = {
      service_name    = "Microsoft.Network/dnsResolvers"
      service_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
  depends_on = [
    module.dns_resolver_vnet,
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
  virtual_network_name        = local.resolver_vnet_name
  delegations = {
    outbound_dns_resolver = {
      service_name    = "Microsoft.Network/dnsResolvers"
      service_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

  depends_on = [
    module.dns_resolver_vnet,
    module.network_security_group,
    #     module.route_table,
  ]
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
  virtual_network_id     = module.dns_resolver_vnet.vnet_id
  # TODO add forwarding to Azure-provided DNS for public DNS resolution
  # TODO add outound endpoint to "on-premises" DNS servers for corporate DNS resolution
}

module "hub_vnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.1"

  address_space       = [var.hub_vnet_address_space]
  resource_group_name = module.resource_group.name
  vnet_location       = var.location
  vnet_name           = local.hub_vnet_name
  dns_servers         = [module.private_dns_resolver.private_dns_resolver_ip]
  depends_on          = [module.resource_group, module.network_security_group]
}

module "peer_hub_vnet_to_resolver_vnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/vnet_peering/azurerm"
  version = "~> 1.2"

  peering_name                 = "peer_hub_to_resolver" # "peer${local.hub_vnet_name}_to_${local.resolver_vnet_name}"
  resource_group_name          = module.resource_group.name
  virtual_network_name         = local.hub_vnet_name
  remote_virtual_network_id    = module.dns_resolver_vnet.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [module.hub_vnet, module.dns_resolver_vnet]
}

module "peer_resolver_vnet_to_hub_vnet" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/vnet_peering/azurerm"
  version = "~> 1.2"

  peering_name                 = "peer_resolver_to_hub" # "peer${local.resolver_vnet_name}_to_${local.hub_vnet_name}"
  resource_group_name          = module.resource_group.name
  virtual_network_name         = local.resolver_vnet_name
  remote_virtual_network_id    = module.hub_vnet.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [module.dns_resolver_vnet, module.hub_vnet]
}
