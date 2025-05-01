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

variable "spoke_subscription_ids" {
  type        = set(string)
  description = "Subscription IDs to associate with the management group."
}

variable "hub_vnet_address_space" {
  description = "The address prefix for the hub network. Use slash notation"
  type        = string
  default     = "10.53.0.0/16" # Default value for the virtual network address prefix, can be overridden
}

variable "resolver_vnet_address_space" {
  description = "The address prefix for the DNS resolver network. Use slash notation"
  type        = string
  default     = "10.54.0.0/16" # Default value for the virtual network address prefix, can be overridden
}

variable "inbound_dns_subnet_address_space" {
  description = "The address prefix for the inbound DNS subnet. Use slash notation"
  type        = string
  default     = "10.54.0.0/26"
}

variable "outbound_dns_subnet_address_space" {
  description = "The address prefix for the outbound DNS subnet. Use slash notation"
  type        = string
  default     = "10.54.0.64/26"
}
