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
# azure_private_dns_zones = {
#   blob.core.windows.net = {
#     name         = "deploy-prvt-dns-blob-stg"
#     display_name = "Configure Azure Blob Storage to use private DNS zones"
#     description  = "Ensures private endpoints to Azure Blob Storage are integrated with Azure Private DNS zones"
#   }
#   vaultcore.azure.net = {
#     name         = "deploy-prvt-dns-kvs"
#     display_name = "Configure Azure Keyvaults to use private DNS zones"
#     description  = "Ensures private endpoints to Azure Keyvaults are integrated with Azure Private DNS zones"
#   }
#   queue.core.windows.net = {
#     name         = "dply-prvt-dns-queue"
#     display_name = "Configure Azure Storage Account queues to use private DNS zones"
#     description  = "Ensures private endpoints to Azure Storage Account queues are integrated with Azure Private DNS zones"
#   }
# }
locals {
  policy_definitions = {
    "blob.core.windows.net" = {
      policy_ids = [
        "75973700-529f-4de2-b794-fb9b6781b6b0",
        "d847d34b-9337-4e2d-99a5-767e5ac9c582"
      ]
    }
    "vaultcore.azure.net" = {
      policy_ids = [
        "ac673a9a-f77d-4846-b2d8-a57f8e1c01d4"
      ]
    }
    "queue.core.windows.net" = {
      policy_ids = [
        "bcff79fb-2b0d-47c9-97e5-3023479b00d1"
      ]
    }
  }
  policy_assignments = flatten([
    for domain in keys(var.private_dns_zones) : [
      for policy_id in local.policy_definitions[domain].policy_ids : {
        policy_id               = policy_id
        assignment_name         = var.private_dns_zones[domain].assignment_name
        assignment_display_name = var.private_dns_zones[domain].assignment_display_name
        assignment_description  = var.private_dns_zones[domain].assignment_description
        private_dns_zone_id     = var.private_dns_zones[domain].private_dns_zone_id
      }
    ]
  ])
}

resource "azurerm_management_group_policy_assignment" "pe_dns_policy" {
  for_each = tomap({
    for assignment in local.policy_assignments : assignment.policy_id => assignment
  })

  name                 = each.value.assignment_name
  display_name         = each.value.assignment_display_name
  description          = each.value.assignment_description
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/${each.value.policy_id}"
  management_group_id  = module.management_group.management_group.id
  parameters           = <<PARAMETERS
    {
      "privateDnsZoneId": {
        "value": "${each.value.private_dns_zone_id}"
      }
    }
PARAMETERS

  location = var.location
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
  }
}
