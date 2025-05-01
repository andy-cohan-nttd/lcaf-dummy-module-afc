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

# use builtin policy definition to deploy private dns zone for keyvaults
resource "azurerm_management_group_policy_assignment" "deploy_private_dns_zone_keyvaults" {
  name                 = var.keyvault_dns_policy.name         # "deploy-prvt-dns-kvs"
  display_name         = var.keyvault_dns_policy.display_name # "Configure Azure Keyvaults to use private DNS zones"
  description          = var.keyvault_dns_policy.description  # "Ensures private endpoints to Azure Keyvaults are integrated with Azure Private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4"
  management_group_id  = module.management_group.management_group.id
  parameters           = <<PARAMETERS
    {
      "privateDnsZoneId": {
        "value": "${var.keyvault_private_dns_zone_id}"
      }
    }
PARAMETERS

  location = var.location
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
  }
}
