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

variable "environment" {
  description = "Environment name e.g. sandbox"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created. This should be a valid Azure region."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "product_family" {
  description = "The product family for the resources, used for naming conventions."
  type        = string
}

variable "spoke_vnet_address_space" {
  description = "The address prefix for the spoke network. Use slash notation"
  type        = string
  default     = "10.55.0.0/16" # Default value for the virtual network address prefix, can be overridden
}

variable "storage_subnet_address_space" {
  description = "The address prefix for the storage subnet. Use slash notation"
  type        = string
  default     = "10.55.0.0/26"
}

variable "private_dns_resolver_ip" {
  description = "The IP address of the private DNS resolver"
  type        = string
}

variable "hub_vnet" {
  type = object({
    name           = string
    resource_group = string
  })
  description = "coordinates of the hub virtual network"
}

variable "resolver_vnet" {
  type = object({
    name           = string
    resource_group = string
  })
  description = "coordinates of the resolver virtual network"
}
