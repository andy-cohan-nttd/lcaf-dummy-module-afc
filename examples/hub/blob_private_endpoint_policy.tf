# use builtin policy definition to deploy private dns zone for blob storage
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
# TODO add for privatelink zones also?
