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

  deployment_identity_name      = module.resource_names["deployer"].minimal_random_suffix
  location                      = var.location
  private_dns_resource_group_id = module.resource_group.id
  resource_group_name           = module.resource_group.name
  spoke_subscription_ids        = var.spoke_subscription_ids
  management_group = {
    name         = module.resource_names["mgmtgrp"].standard
    display_name = "Management Group for PDNS Policy"
  }
  deny_private_dns_zone_policy = {
    name         = "deny-prvt-dns-zone"
    display_name = "Deny Private DNS Zone Creation"
    description  = "Denies creation of private DNS zones with the `privatelink` prefix"
  }
  storage_public_access_policy = {
    name         = "deny-public-strg-access"
    display_name = "Deny Public Storage Access"
    description  = "Denies public access to all storage accounts"
  }
  private_dns_zones = {
    "blob.core.windows.net" = {
      assignment_name         = "deploy-prvt-dns-blob-stg"
      assignment_display_name = "Configure Azure Blob Storage to use private DNS zones"
      assignment_description  = "Ensures private endpoints to Azure Blob Storage are integrated with Azure Private DNS zones"
      private_dns_zone_id     = azurerm_private_dns_zone.privatelink_dns_zone["blob.core.windows.net"].id
    }
    "vaultcore.azure.net" = {
      assignment_name         = "deploy-prvt-dns-kvs"
      assignment_display_name = "Configure Azure Keyvaults to use private DNS zones"
      assignment_description  = "Ensures private endpoints to Azure Keyvaults are integrated with Azure Private DNS zones"
      private_dns_zone_id     = azurerm_private_dns_zone.privatelink_dns_zone["vaultcore.azure.net"].id
    }
    "queue.core.windows.net" = {
      assignment_name         = "dply-prvt-dns-queue"
      assignment_display_name = "Configure Azure Storage Account queues to use private DNS zones"
      assignment_description  = "Ensures private endpoints to Azure Storage Account queues are integrated with Azure Private DNS zones"
      private_dns_zone_id     = azurerm_private_dns_zone.privatelink_dns_zone["queue.core.windows.net"].id
    }
  }
  depends_on = [module.resource_group]
}
