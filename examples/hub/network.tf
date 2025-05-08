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
  hub_vnet_name = module.resource_names["hvnet"].recommended_per_length_restriction
  nsg_name      = module.resource_names["nsg"].minimal_random_suffix
  azure_private_zones = [
    "blob.core.windows.net",
    "vaultcore.azure.net"
    # "afs.azure.net",
    # "dfs.core.windows.net",
    # "file.core.windows.net",
    # "queue.core.windows.net",
    # "table.core.windows.net",
    # "web.core.windows.net",
  ]
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
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.1"

  address_space       = [var.hub_vnet_address_space]
  resource_group_name = module.resource_group.name
  vnet_location       = var.location
  vnet_name           = local.hub_vnet_name
  depends_on          = [module.resource_group, module.network_security_group]
}

resource "azurerm_private_dns_zone" "privatelink_dns_zone" {
  for_each = toset(local.azure_private_zones)

  name                = "privatelink.${each.value}"
  resource_group_name = module.resource_group.name
  depends_on          = [module.resource_group]
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
