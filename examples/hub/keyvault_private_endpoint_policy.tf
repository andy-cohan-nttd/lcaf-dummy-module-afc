# use builtin policy definition to deploy private dns zone for keyvaults
resource "azurerm_management_group_policy_assignment" "deploy_private_dns_zone_keyvaults" {
  name                 = "deploy-prvt-dns-kvs"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4"
  management_group_id  = module.management_group.management_group.id
  display_name         = "Configure Azure Keyvaults to use private DNS zones"
  description          = "Ensures private endpoints to Azure Keyvaults are integrated with Azure Private DNS zones"
  parameters           = <<PARAMETERS
    {
      "privateDnsZoneId": {
        "value": "${azurerm_private_dns_zone.dns_zone["vaultcore.azure.net"].id}"
      }
    }
PARAMETERS

  location = var.location
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
  }
}
