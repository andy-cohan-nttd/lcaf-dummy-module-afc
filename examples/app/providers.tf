provider "azurerm" {
  # alias          = "spoke"
  subscription_id            = "9a75417b-0956-4b5a-b243-328ec6c522b4" # spoke/app subscription is iac.platform
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = "4554e249-e00f-4668-9be3-da31ed200163" # hub subscription is sandbox.platform
  features {}
}
