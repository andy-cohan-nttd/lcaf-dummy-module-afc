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

variable "management_group" {
  type = object({
    name         = string
    display_name = string
  })
  description = "Management group values"
}

variable "spoke_subscription_ids" {
  type        = set(string)
  description = "Subscription IDs for the spoke subscriptions"
}

variable "deployment_identity_name" {
  type        = string
  description = "Name of the user assigned identity for deployment"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group into which the resources will be deployed"
}

variable "location" {
  type        = string
  description = "Azure region of the deployed resources"
}

variable "private_dns_resource_group_id" {
  type        = string
  description = "Resource group ID where the privatelink DNS zones reside"
}

variable "deny_private_dns_zone_policy" {
  type = object({
    name         = string
    display_name = string
    description  = string
  })
}
variable "private_dns_zones" {
  description = "Map of Azure Private DNS zones to create policies for, such that private DNS entries are created for the specified services."
  type = map(object({
    assignment_name         = string
    assignment_display_name = string
    assignment_description  = string
    private_dns_zone_id     = string
  }))
}

variable "storage_public_access_policy" {
  type = object({
    name         = string
    display_name = string
    description  = string
  })
}
