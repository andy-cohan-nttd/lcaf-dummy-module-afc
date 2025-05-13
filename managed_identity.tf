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

resource "azurerm_user_assigned_identity" "auto_deploy_identity" {
  name                = var.deployment_identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "hub_dns_contributor" {
  scope                = var.private_dns_resource_group_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.auto_deploy_identity.principal_id
}

resource "azurerm_role_assignment" "spoke_contributor" {
  for_each = var.spoke_subscription_ids
  scope    = "/subscriptions/${each.value}"

  role_definition_name = "Contributor" # TODO try to use "Network Contributor" instead
  principal_id         = azurerm_user_assigned_identity.auto_deploy_identity.principal_id
}
