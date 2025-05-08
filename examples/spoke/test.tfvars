environment    = "sandbox"
location       = "eastus2"
product_family = "pdnsadms"
tags = {
  Environment = "sandbox"
  ManagedBy   = "Terragrunt"
}
hub_vnet = {
  name           = "pdnsadmhtestsandbox000hvnet"
  resource_group = "pdnsadmh-test-eastus2-sandbox-000-rg-000"
}
