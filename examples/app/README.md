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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | ../../../../launchbynttdata/tf-launch-module_library-resource_name | n/a |
| <a name="module_sa_names"></a> [sa\_names](#module\_sa\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.1 |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ../../../../launchbynttdata/tf-azurerm-module_primitive-storage_account | n/a |
| <a name="module_storage_private_endpoint"></a> [storage\_private\_endpoint](#module\_storage\_private\_endpoint) | ../../../../launchbynttdata/tf-azurerm-module_primitive-private_endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.storage_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name e.g. sandbox | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created. This should be a valid Azure region. | `string` | n/a | yes |
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | The product family for the resources, used for naming conventions. | `string` | n/a | yes |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | Path to the SSH public key for VM access | `string` | `"~/.ssh/id_lcaf.pub"` | no |
| <a name="input_storage_subnet"></a> [storage\_subnet](#input\_storage\_subnet) | Storage subnet configuration | <pre>object({<br/>    subnet_name    = string<br/>    vnet_name      = string<br/>    resource_group = string<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vm_subnet"></a> [vm\_subnet](#input\_vm\_subnet) | VM subnet configuration | <pre>object({<br/>    subnet_name    = string<br/>    vnet_name      = string<br/>    resource_group = string<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
