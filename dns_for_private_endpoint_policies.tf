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
  policy_definitions = {
    "blob.core.windows.net" = {
      policy_ids = [
        "75973700-529f-4de2-b794-fb9b6781b6b0", # https://www.azadvertizer.net/azpolicyadvertizer/75973700-529f-4de2-b794-fb9b6781b6b0.html
        "d847d34b-9337-4e2d-99a5-767e5ac9c582"  # https://www.azadvertizer.net/azpolicyadvertizer/d847d34b-9337-4e2d-99a5-767e5ac9c582.html
      ]
    }
    "vaultcore.azure.net" = {
      policy_ids = [
        "ac673a9a-f77d-4846-b2d8-a57f8e1c01d4" # https://www.azadvertizer.net/azpolicyadvertizer/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4.html
      ]
    }
    "queue.core.windows.net" = {
      policy_ids = [
        "bcff79fb-2b0d-47c9-97e5-3023479b00d1" # https://www.azadvertizer.net/azpolicyadvertizer/bcff79fb-2b0d-47c9-97e5-3023479b00d1.html
      ]
    }
    # TODO add the rest of the most common Azure services
  }
  policy_assignments = flatten([
    # for each given private DNS zone
    for domain in keys(var.private_dns_zones) : [
      # for each policy id for the given private DNS zone
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

  description          = each.value.assignment_description
  display_name         = each.value.assignment_display_name
  management_group_id  = module.management_group.management_group.id
  name                 = "${substr(each.value.assignment_name, 0, 18)}-${substr(each.value.policy_id, 0, 5)}" # uniquify
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/${each.value.policy_id}"
  location             = var.location
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
  }
  parameters = <<PARAMETERS
    {
      "privateDnsZoneId": {
        "value": "${each.value.private_dns_zone_id}"
      }
    }
PARAMETERS
}
