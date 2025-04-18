# when a contributor creates a private endpoint
# the policy will automatically register it with the centralized zone
resource "azurerm_policy_definition" "private_endpoint" {
  name                = module.short_names["pol"].minimal_random_suffix
  policy_type         = var.policy_type
  mode                = var.policy_mode
  display_name        = "Private Endpoint DNS Policy"
  management_group_id = module.management_group.management_group.id

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

  # policy_rule = <<POLICY_RULE
  # {
  #   "if": {
  #     "field": "type",
  #     "equals": "Microsoft.Network/privateEndpoints"
  #   },
  #   "then": {
  #     "effect": "audit"
  #   }
  # }
  # POLICY_RULE

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

resource "azurerm_user_assigned_identity" "auto_deploy_identity" {
  name                = local.deployment_identity_name
  resource_group_name = module.resource_group.name
  location            = var.location
  depends_on          = [module.resource_group]
}

locals {
  zones = jsonencode(tolist(var.private_dns_zones))
}

# resource "azurerm_management_group_policy_assignment" "private_endpoint" {
#   # for_each = var.private_dns_zones

#   # name                 = substr("${substr(each.key, 1, 8)}.${var.policy_name}", 0, 24)
#   name                 = var.policy_name
#   policy_definition_id = azurerm_policy_definition.private_endpoint.id
#   management_group_id  = var.management_group.id
#   # description          = "Private Endpoint DNS Policy Assignment for ${each.key}"
#   description  = "Private Endpoint DNS Policy Assignment"
#   display_name = var.policy_display_name
#   enforce      = false
#   parameters   = <<PARAMETERS
#     {
#       "privateDnsZoneName": {
#         "value": "privatelink.${jsonencode(tolist(var.private_dns_zones))}"
#       }
#     }
# PARAMETERS

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.auto_deploy_identity.id]
#   }
#   location = var.location
# }
