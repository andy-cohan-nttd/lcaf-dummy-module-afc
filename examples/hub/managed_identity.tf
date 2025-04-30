resource "azurerm_user_assigned_identity" "auto_deploy_identity" {
  name                = local.deployment_identity_name
  resource_group_name = module.resource_group.name
  location            = var.location
  depends_on          = [module.resource_group]
}

resource "azurerm_role_assignment" "auto_deploy_identity" {
  scope                = module.resource_group.id
  role_definition_name = "Private DNS Zone Contributor"
  # role_definition_name = "Contributor"
  # role_definition_name = "Network Contributor"
  principal_id = azurerm_user_assigned_identity.auto_deploy_identity.principal_id
}
