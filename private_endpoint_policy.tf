# when a contributor creates a private endpoint
# the policy will automatically register it with the centralized zone
resource "azurerm_policy_definition" "private_endpoint" {
  name         = var.policy_name
  policy_type  = var.policy_type
  mode         = var.policy_mode
  display_name = var.policy_display_name

  metadata = <<METADATA
    {
      "category": "General"
    }
METADATA

  parameters = <<PARAMETERS
    {
      "privateDnsZoneName": {
        "type": "String",
        "metadata": {
          "description": "The name of the private DNS zone where the DNS entry should be created."
        }
      }
    }
PARAMETERS

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "equals": "Microsoft.Network/privateEndpoints"
      },
      "then": {
        "effect": "DeployIfNotExists",
        "details": {
          "type": "Microsoft.Network/privateDnsZones/A",
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/contributor"
          ],
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "resources": [
                  {
                    "type": "Microsoft.Network/privateDnsZones/A",
                    "apiVersion": "2020-06-01",
                    "name": "[concat(parameters('privateDnsZoneName'), '/', field('name'))]",
                    "location": "global",
                    "properties": {
                      "ttl": 3600,
                      "aRecords": [
                        {
                          "ipv4Address": "[field('properties.privateLinkServiceConnections[0].privateLinkServiceIpAddress')]"
                        }
                      ]
                    }
                  }
                ],
                "parameters": {
                  "privateDnsZoneName": {
                    "type": "string"
                  }
                }
              }
            }
          },
          "existenceCondition": {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Network/privateDnsZones/A"
              },
              {
                "field": "name",
                "equals": "[concat(parameters('privateDnsZoneName'), '/', field('name'))]"
              }
            ]
          }
        }
      }
    }
POLICY_RULE

}

resource "azurerm_management_group_policy_assignment" "private_endpoint" {
  name                 = "${var.policy_name}-assign"
  policy_definition_id = azurerm_policy_definition.private_endpoint.id
  management_group_id  = var.management_group.id
}
