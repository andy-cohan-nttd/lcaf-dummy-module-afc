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
| <a name="module_hub_vnet"></a> [hub\_vnet](#module\_hub\_vnet) | ../../../../launchbynttdata/tf-azurerm-module_primitive-virtual_network | n/a |
| <a name="module_inbound_dns_subnet"></a> [inbound\_dns\_subnet](#module\_inbound\_dns\_subnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm | ~> 1.1 |
| <a name="module_management_group"></a> [management\_group](#module\_management\_group) | ../../../../launchbynttdata/tf-azurerm-module_primitive-management_group | n/a |
| <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group) | terraform.registry.launch.nttdata.com/module_primitive/network_security_group/azurerm | ~> 1.0 |
| <a name="module_outbound_dns_subnet"></a> [outbound\_dns\_subnet](#module\_outbound\_dns\_subnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm | ~> 1.1 |
| <a name="module_peer_hub_vnet_to_spoke_vnet"></a> [peer\_hub\_vnet\_to\_spoke\_vnet](#module\_peer\_hub\_vnet\_to\_spoke\_vnet) | ../../../../launchbynttdata/tf-azurerm-module_primitive-vnet_peering | n/a |
| <a name="module_peer_spoke_vnet_to_hub_vnet"></a> [peer\_spoke\_vnet\_to\_hub\_vnet](#module\_peer\_spoke\_vnet\_to\_hub\_vnet) | ../../../../launchbynttdata/tf-azurerm-module_primitive-vnet_peering | n/a |
| <a name="module_private_dns_resolver"></a> [private\_dns\_resolver](#module\_private\_dns\_resolver) | ../../../tf-azurerm-module_collection-private_dns_resolver | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | ../../../../launchbynttdata/tf-launch-module_library-resource_name | n/a |
| <a name="module_short_names"></a> [short\_names](#module\_short\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.1 |
| <a name="module_spoke_vnet"></a> [spoke\_vnet](#module\_spoke\_vnet) | ../../../../launchbynttdata/tf-azurerm-module_primitive-virtual_network | n/a |
| <a name="module_storage_subnet"></a> [storage\_subnet](#module\_storage\_subnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm | ~> 1.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_definition.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_user_assigned_identity.auto_deploy_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network_dns_servers.hub_vnet_dns_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_virtual_network_dns_servers.spoke_vnet_dns_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name e.g. sandbox | `string` | n/a | yes |
| <a name="input_hub_vnet_address_space"></a> [hub\_vnet\_address\_space](#input\_hub\_vnet\_address\_space) | The address prefix for the hub network. Use slash notation | `string` | `"10.53.0.0/16"` | no |
| <a name="input_inbound_dns_subnet_address_space"></a> [inbound\_dns\_subnet\_address\_space](#input\_inbound\_dns\_subnet\_address\_space) | The address prefix for the inbound DNS subnet. Use slash notation | `string` | `"10.53.0.64/26"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created. This should be a valid Azure region. | `string` | n/a | yes |
| <a name="input_outbound_dns_subnet_address_space"></a> [outbound\_dns\_subnet\_address\_space](#input\_outbound\_dns\_subnet\_address\_space) | The address prefix for the outbound DNS subnet. Use slash notation | `string` | `"10.53.0.0/26"` | no |
| <a name="input_policy_mode"></a> [policy\_mode](#input\_policy\_mode) | The mode of the policy definition | `string` | `"Indexed"` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | The type of the policy definition. Can be 'Custom', 'BuiltIn', 'NotSpecified' or 'Static'. | `string` | `"Custom"` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | The names of the private DNS zones to be monitored. | `set(string)` | `[]` | no |
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | The product family for the resources, used for naming conventions. | `string` | n/a | yes |
| <a name="input_spoke_vnet_address_space"></a> [spoke\_vnet\_address\_space](#input\_spoke\_vnet\_address\_space) | The address prefix for the spoke network. Use slash notation | `string` | `"10.54.0.0/16"` | no |
| <a name="input_storage_subnet_address_space"></a> [storage\_subnet\_address\_space](#input\_storage\_subnet\_address\_space) | The address prefix for the storage subnet. Use slash notation | `string` | `"10.54.0.64/26"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
