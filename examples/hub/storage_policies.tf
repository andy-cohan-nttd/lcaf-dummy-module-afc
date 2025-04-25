# disallow public access to all storage accounts
resource "azurerm_management_group_policy_assignment" "deny_public_storage_access" {
  name                 = "deny-public-strg-access"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
  management_group_id  = module.management_group.management_group.id
  display_name         = "Deny Public Storage Access"
  description          = "This policy restricts public access to all storage accounts"
  enforce              = true
}

resource "azurerm_management_group_policy_assignment" "ensure_customer_managed_key" {
  name                 = "ensure-customer-mngd-key"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25"
  management_group_id  = module.management_group.management_group.id
  display_name         = "Ensure Customer Managed Key for Storage Accounts"
  description          = "Ensures that all storage accounts are encrypted with a customer-managed key"
  enforce              = true
}
