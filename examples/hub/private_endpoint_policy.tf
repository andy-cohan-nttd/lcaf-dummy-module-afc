locals {
  zones = jsonencode(tolist(var.private_dns_zones))
}

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

# disallow privatelink DNS zones from being created in the subscription
resource "azurerm_policy_definition" "deny_private_dns_zone_creation" {
  name                = module.short_names["poldns"].minimal_random_suffix
  display_name        = "Deny Private DNS Zone Creation"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = module.management_group.management_group.id
  description         = "This policy restricts creation of private DNS zones with the `privatelink` prefix"

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

resource "azurerm_management_group_policy_assignment" "deploy_private_dns_zone_blob_storage" {
  name                 = "deploy-prvt-dns-blob-stg"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/75973700-529f-4de2-b794-fb9b6781b6b0"
  management_group_id  = module.management_group.management_group.id
  display_name         = "Configure Azure Blob Storage to use private DNS zones"
  description          = "Ensures private endpoints to Azure Blob Storage are integrated with Azure Private DNS zones"
  parameters           = <<PARAMETERS
    {
      "privateDnsZoneId": {
        "value": "${azurerm_private_dns_zone.dns_zone["blob.core.windows.net"].id}"
      }
    }
PARAMETERS

  location = var.location
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
  }
}
