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

module "management_group" {
  # source  = "terraform.registry.launch.nttdata.com/module_primitive/management_group/azurerm"
  # version = "~> 1.0"
  source = "../../launchbynttdata/tf-azurerm-module_primitive-management_group" # Use the local path for testing

  name             = var.management_group.name
  display_name     = var.management_group.display_name
  subscription_ids = tolist(var.spoke_subscription_ids)
}
