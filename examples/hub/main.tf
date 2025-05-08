// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.1"

  for_each = local.resource_names

  logical_product_family  = var.product_family
  logical_product_service = "test"
  region                  = var.location
  class_env               = var.environment
  cloud_resource_type     = each.value
  maximum_length          = 32
}

module "short_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.1"

  for_each = toset(["sa", "polsa", "poldns", "polga"])

  logical_product_family  = var.product_family
  logical_product_service = "test"
  region                  = var.location
  class_env               = var.environment
  cloud_resource_type     = each.value
  maximum_length          = 20
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = module.resource_names["rg"].standard
  location = var.location
  tags     = var.tags
}

module "management_group" {
  source = "../.."

  blob_private_dnz_zone_id      = azurerm_private_dns_zone.privatelink_dns_zone["blob.core.windows.net"].id
  deploy_identity_name          = module.resource_names["deployer"].minimal_random_suffix
  keyvault_private_dns_zone_id  = azurerm_private_dns_zone.privatelink_dns_zone["vaultcore.azure.net"].id
  location                      = var.location
  private_dns_resource_group_id = module.resource_group.id
  resource_group_name           = module.resource_group.name
  spoke_subscription_ids        = var.spoke_subscription_ids
  management_group = {
    name         = module.resource_names["mgmtgrp"].standard
    display_name = "Management Group for PDNS Policy"
  }
  deny_private_dns_zone_policy = {
    name         = module.short_names["poldns"].minimal_random_suffix
    display_name = "Deny Private DNS Zone Creation"
    description  = "This policy restricts creation of private DNS zones with the `privatelink` prefix"
  }
  blob_dns_policy = {
    name         = "deploy-prvt-dns-blob-stg"
    display_name = "Configure Azure Blob Storage to use private DNS zones"
    description  = "Ensures private endpoints to Azure Blob Storage are integrated with Azure Private DNS zones"
  }
  keyvault_dns_policy = {
    name         = "deploy-prvt-dns-kvs"
    display_name = "Configure Azure Keyvaults to use private DNS zones"
    description  = "Ensures private endpoints to Azure Keyvaults are integrated with Azure Private DNS zones"
  }
  storage_public_access_policy = {
    name         = "deny-public-strg-access"
    display_name = "Deny Public Storage Access"
    description  = "This policy restricts public access to all storage accounts"
  }
  depends_on = [module.resource_group]
}
