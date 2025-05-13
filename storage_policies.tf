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

# disallow public access to all storage accounts
resource "azurerm_management_group_policy_assignment" "deny_public_storage_access" {
  # TODO make conditional
  name                 = var.storage_public_access_policy.name
  display_name         = var.storage_public_access_policy.display_name
  description          = var.storage_public_access_policy.description
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
  management_group_id  = module.management_group.management_group.id
  enforce              = true
}

# TODO add this conditionally
# resource "azurerm_management_group_policy_assignment" "ensure_customer_managed_key" {
#   name                 = "ensure-customer-mngd-key"
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25"
#   management_group_id  = module.management_group.management_group.id
#   display_name         = "Ensure Customer Managed Key for Storage Accounts"
#   description          = "Ensures that all storage accounts are encrypted with a customer-managed key"
#   enforce              = true
# }
