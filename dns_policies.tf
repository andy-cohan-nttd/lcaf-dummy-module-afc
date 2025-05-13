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

# disallow privatelink DNS zones from being created in the subscription
resource "azurerm_policy_definition" "deny_private_dns_zone_creation" {
  name                = var.deny_private_dns_zone_policy.name
  display_name        = var.deny_private_dns_zone_policy.display_name
  description         = var.deny_private_dns_zone_policy.description
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = module.management_group.management_group.id

  metadata = <<METADATA
    {
      "category": "General"
    }
METADATA

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/privateDnsZones"
        },
        {
          "field": "name",
          "contains": "privatelink."
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE

}

resource "azurerm_management_group_policy_assignment" "deny_private_dns_zone_creation" {
  name                 = "deny-prvt-dns-zn-create"
  policy_definition_id = azurerm_policy_definition.deny_private_dns_zone_creation.id
  management_group_id  = module.management_group.management_group.id
  display_name         = "Deny Private DNS Zone Creation"
  description          = "This policy restricts creation of private DNS zones with the `privatelink` prefix"
}
