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
  kv_name = module.resource_names["kv"].recommended_per_length_restriction
}

module "keyvault" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/key_vault/azurerm"
  version = "~> 2.1"

  key_vault_name = local.kv_name
  resource_group = {
    name     = module.resource_group.name
    location = var.location
  }
  custom_tags = var.tags

  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "kv_pe" {
  name                = module.resource_names["kvpe"].standard
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = data.azurerm_subnet.app_subnet.id

  private_service_connection {
    name                           = "pe-${local.kv_name}"
    private_connection_resource_id = module.keyvault.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
