# basic

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
| <a name="module_management_group"></a> [management\_group](#module\_management\_group) | ../../../../launchbynttdata/tf-azurerm-module_primitive-management_group | n/a |
| <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group) | terraform.registry.launch.nttdata.com/module_primitive/network_security_group/azurerm | ~> 1.0 |
| <a name="module_outbound_dns_subnet"></a> [outbound\_dns\_subnet](#module\_outbound\_dns\_subnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm | ~> 1.1 |
| <a name="module_private_dns_policy"></a> [private\_dns\_policy](#module\_private\_dns\_policy) | ../../ | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.1 |
| <a name="module_route_table"></a> [route\_table](#module\_route\_table) | terraform.registry.launch.nttdata.com/module_primitive/route_table/azurerm | ~> 1.0 |
| <a name="module_sa_names"></a> [sa\_names](#module\_sa\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.1 |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm | ~> 1.3 |
| <a name="module_storage_subnet"></a> [storage\_subnet](#module\_storage\_subnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm | ~> 1.1 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_resolver.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_dns_forwarding_ruleset) | resource |
| [azurerm_private_dns_resolver_outbound_endpoint.test_ob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_outbound_endpoint) | resource |
| [azurerm_private_dns_resolver_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_virtual_network_link) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name e.g. sandbox | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created. This should be a valid Azure region. | `string` | n/a | yes |
| <a name="input_outbound_dns_subnet_address_prefix"></a> [outbound\_dns\_subnet\_address\_prefix](#input\_outbound\_dns\_subnet\_address\_prefix) | The address prefix for the outbound DNS subnet. Use slash notation | `string` | `"10.53.0.0/26"` | no |
| <a name="input_parent_management_group_id"></a> [parent\_management\_group\_id](#input\_parent\_management\_group\_id) | The ID of the parent management group for creating the management group. Leave empty for root. | `string` | `""` | no |
| <a name="input_storage_subnet_address_prefix"></a> [storage\_subnet\_address\_prefix](#input\_storage\_subnet\_address\_prefix) | The address prefix for the storage subnet. Use slash notation | `string` | `"10.53.0.64/26"` | no |
| <a name="input_subscription_ids"></a> [subscription\_ids](#input\_subscription\_ids) | List of subscription IDs to associate with the management group. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix for the virtual network. Use slash notation | `string` | `"10.53.0.0/16"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
