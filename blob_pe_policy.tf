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
# locals {
#   policy_definitions = {
#     "blob" = {
#       policy_id    = "75973700-529f-4de2-b794-fb9b6781b6b0"
#       name         = var.blob_dns_policy.name
#       display_name = var.blob_dns_policy.display_name
#       description  = var.blob_dns_policy.description
#       zone_id      = var.blob_dns_policy.private_dns_zone_id
#     }
#     "blob_2nd" = {
#       policy_id    = "d847d34b-9337-4e2d-99a5-767e5ac9c582"
#       name         = var.blob_2nd_dns_policy.name
#       display_name = var.blob_2nd_dns_policy.display_name
#       description  = var.blob_2nd_dns_policy.description
#       zone_id      = var.blob_2nd_dns_policy.private_dns_zone_id
#     }
#     "queue" = {
#       policy_id    = "bcff79fb-2b0d-47c9-97e5-3023479b00d1"
#       name         = var.queue_dns_policy.name
#       display_name = var.queue_dns_policy.display_name
#       description  = var.queue_dns_policy.description
#       zone_id      = var.queue_dns_policy.private_dns_zone_id
#     }
#   }
# }

# # use builtin policy definition to deploy private dns zone for blob storage
# resource "azurerm_management_group_policy_assignment" "private_dns_zone_blob_storage" {
#   for_each = local.policy_definitions

#   name                 = local.policy_definitions[each.key].name
#   display_name         = local.policy_definitions[each.key].display_name
#   description          = local.policy_definitions[each.key].description
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/${local.policy_definitions[each.key].policy_id}"
#   management_group_id  = module.management_group.management_group.id
#   parameters           = <<PARAMETERS
#     {
#       "privateDnsZoneId": {
#         "value": "${local.policy_definitions[each.key].zone_id}"
#       }
#     }
# PARAMETERS

#   location = var.location
#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
#   }
# }
