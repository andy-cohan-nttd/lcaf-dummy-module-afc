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

# use builtin policy definition to deploy private dns zone for blob storage
resource "azurerm_management_group_policy_assignment" "deploy_private_dns_zone_blob_storage" {
  name                 = var.blob_dns_policy.name         # "deploy-prvt-dns-blob-stg"
  display_name         = var.blob_dns_policy.display_name # "Configure Azure Blob Storage to use private DNS zones"
  description          = var.blob_dns_policy.description  # "Ensures private endpoints to Azure Blob Storage are integrated with Azure Private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/75973700-529f-4de2-b794-fb9b6781b6b0"
  management_group_id  = module.management_group.management_group.id
  parameters           = <<PARAMETERS
    {
      "privateDnsZoneId": {
        "value": "${var.blob_private_dnz_zone_id}"
      }
    }
PARAMETERS

  location = var.location
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
  }
}
