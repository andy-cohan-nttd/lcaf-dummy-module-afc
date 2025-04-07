resource "azurerm_policy_definition" "location" {
  name         = "${var.name}-loc"
  policy_type  = var.policy_type
  mode         = var.policy_mode
  display_name = var.display_name

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  policy_rule = <<POLICY_RULE
   {
      "if": {
        "not": {
          "field": "location",
          "in": "[parameters('allowedLocations')]"
        }
      },
      "then": {
        "effect": "audit"
      }
   }
POLICY_RULE

  parameters = <<PARAMETERS
    {
      "allowedLocations": {
        "type": "Array",
        "metadata": {
          "description": "The list of allowed locations for resources.",
          "displayName": "Allowed locations",
          "strongType": "location"
        },
        "defaultValue": [
          "eastus2",
          "centralus"
        ]
      }
    }
PARAMETERS

}

resource "azurerm_management_group_policy_assignment" "location" {
  name                 = "${var.name}-assignment"
  policy_definition_id = azurerm_policy_definition.location.id
  management_group_id  = var.management_group.id
}
