# every time a contributor creates a private endpoint
# the policy will automatically register it with the centralized zone
resource "azurerm_policy_definition" "private_endpoint" {
  name         = "${var.name}-pe" # Ensure the name is unique for the policy definition
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
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/privateEndpoints"
          },
          {
            "not": {
              "field": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].privateLinkServiceId",
              "equals": "[parameters('privateLinkServiceId')]"
            }
          }
        ]
      },
      "then": {
        "effect": "deployIfNotExists",
        "details": {
          "type": "Microsoft.Network/privateEndpoints",
          "name": "registerPrivateEndpoint",
          "operation": "Microsoft.Network/privateEndpoints/write",
          "parameters": {
            "privateLinkServiceId": "[parameters('privateLinkServiceId')]"
          }
        },
        "deployment": {
          "properties": {
            "mode:": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "privateLinkServiceId": {
                  "type": "string",
                  "defaultValue": "[parameters('privateLinkServiceId')]"
                }
              },
              "resources": [
                {
                  "type": "Microsoft.Network/privateEndpoints",
                  "apiVersion": "2021-03-01",
                  "name": "[concat('pe-', uniqueString(resourceGroup().id, utcNow()))]",
                  "location": "[resourceGroup().location]",
                  "properties": {
                    "privateLinkServiceId": "[parameters('privateLinkServiceId')]",
                    "groupIds": ["*"],
                    "subnet": "[variables('subnetId')]"
                  }
                }
              ]
            },
            "parameters": {
              "privateLinkServiceId": {
                "value": "[parameters('privateLinkServiceId')]"
              }
            }
          }
        }
      }
    }
POLICY_RULE

  parameters = <<PARAMETERS
    {
      "privateLinkServiceId": {
        "type": "String",
        "metadata": {
          "description": "The resource ID of the private link service that private endpoints must be associated with.",
          "displayName": "Private Link Service ID"
        }
      }
    }
PARAMETERS

}

resource "azurerm_management_group_policy_assignment" "private_endpoint" {
  name                 = "${var.name}-assignment"
  policy_definition_id = azurerm_policy_definition.private_endpoint.id
  management_group_id  = var.management_group.id
}
