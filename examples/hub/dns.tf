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
