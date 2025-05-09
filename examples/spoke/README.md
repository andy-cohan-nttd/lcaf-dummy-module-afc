# spoke

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm.hub"></a> [azurerm.hub](#provider\_azurerm.hub) | 3.117.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_subnet"></a> [app\_subnet](#module\_app\_subnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network_subnet/azurerm | ~> 1.1 |
| <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group) | terraform.registry.launch.nttdata.com/module_primitive/network_security_group/azurerm | ~> 1.0 |
| <a name="module_peer_hub_vnet_to_spoke_vnet"></a> [peer\_hub\_vnet\_to\_spoke\_vnet](#module\_peer\_hub\_vnet\_to\_spoke\_vnet) | terraform.registry.launch.nttdata.com/module_primitive/vnet_peering/azurerm | ~> 1.2 |
| <a name="module_peer_spoke_vnet_to_hub_vnet"></a> [peer\_spoke\_vnet\_to\_hub\_vnet](#module\_peer\_spoke\_vnet\_to\_hub\_vnet) | terraform.registry.launch.nttdata.com/module_primitive/vnet_peering/azurerm | ~> 1.2 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.1 |
| <a name="module_spoke_vnet"></a> [spoke\_vnet](#module\_spoke\_vnet) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm | ~> 3.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone_virtual_network_link.privatelink_dns_vnet_link_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_virtual_network.hub_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_subnet_address_space"></a> [app\_subnet\_address\_space](#input\_app\_subnet\_address\_space) | The address prefix for the app subnet. Use slash notation | `string` | `"10.55.0.0/26"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name e.g. sandbox | `string` | n/a | yes |
| <a name="input_hub_vnet"></a> [hub\_vnet](#input\_hub\_vnet) | coordinates of the hub virtual network | <pre>object({<br/>    name           = string<br/>    resource_group = string<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created. This should be a valid Azure region. | `string` | n/a | yes |
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | The product family for the resources, used for naming conventions. | `string` | n/a | yes |
| <a name="input_spoke_vnet_address_space"></a> [spoke\_vnet\_address\_space](#input\_spoke\_vnet\_address\_space) | The address prefix for the spoke network. Use slash notation | `string` | `"10.55.0.0/16"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
