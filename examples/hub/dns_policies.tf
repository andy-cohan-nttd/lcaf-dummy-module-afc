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
