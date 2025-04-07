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
variable "name" {
  description = "The name of the policy definition."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
}

variable "display_name" {
  description = "Display name for the policy definition."
  type        = string
}

variable "management_group" {
  description = "Azure Management Group where the policy assignment will be created."
  type = object({
    id   = string
    name = string
  })
}

variable "policy_type" {
  description = "The type of the policy definition. Can be 'Custom', 'BuiltIn', 'NotSpecified' or 'Static'."
  type        = string
  default     = "Custom"
  validation {
    condition     = contains(["Custom", "BuiltIn", "NotSpecified", "Static"], var.policy_type)
    error_message = "The policy_type must be one of 'Custom', 'BuiltIn', 'NotSpecified' or 'Static'."
  }
}

variable "policy_mode" {
  description = "The mode of the policy definition"
  default     = "Indexed"
  validation {
    condition = contains([
      "All",
      "Indexed",
      "Microsoft.ContainerService.Data",
      "Microsoft.CustomerLockbox.Data",
      "Microsoft.DataCatalog.Data",
      "Microsoft.KeyVault.Data",
      "Microsoft.Kubernetes.Data",
      "Microsoft.MachineLearningServices.Data",
      "Microsoft.Network.Data and Microsoft.Synapse.Data"
    ], var.policy_mode)
    error_message = "The policy_mode must be either 'Indexed' or 'All'."
  }
}
