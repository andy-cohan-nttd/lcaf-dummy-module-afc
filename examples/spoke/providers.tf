provider "azurerm" {
  alias                      = "hub"
  subscription_id            = "4554e249-e00f-4668-9be3-da31ed200163"
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
