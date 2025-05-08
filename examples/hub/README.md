# basic

This example creates a hub network with an outbound DNS resolver,
and several subnets for a function app and storage account.

The key test is of the polices which should:
1) enforce the deployment into one of 2 allowed regions
2) add any missing private endpoints to ensure the function app can access the storage account(s) across the private network.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hub_vnet"></a> [hub\_vnet](#module\_hub\_vnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm | ~> 3.1 |
| <a name="module_management_group"></a> [management\_group](#module\_management\_group) | ../.. | n/a |
| <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group) | terraform.registry.launch.nttdata.com/module_primitive/network_security_group/azurerm | ~> 1.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.1 |
| <a name="module_short_names"></a> [short\_names](#module\_short\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.privatelink_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privatelink_dns_vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name e.g. sandbox | `string` | n/a | yes |
| <a name="input_hub_vnet_address_space"></a> [hub\_vnet\_address\_space](#input\_hub\_vnet\_address\_space) | The address prefix for the hub network. Use slash notation | `string` | `"10.53.0.0/16"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created. This should be a valid Azure region. | `string` | n/a | yes |
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | The product family for the resources, used for naming conventions. | `string` | n/a | yes |
| <a name="input_spoke_subscription_ids"></a> [spoke\_subscription\_ids](#input\_spoke\_subscription\_ids) | Subscription IDs to associate with the management group. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
