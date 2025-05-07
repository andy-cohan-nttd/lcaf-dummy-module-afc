environment    = "sandbox"
location       = "eastus2"
product_family = "pdnsadms"
tags = {
  Environment = "sandbox"
  ManagedBy   = "Terragrunt"
}
private_dns_resolver_ip = "10.54.0.4"
hub_vnet = {
  name           = "pdnsadmhtestsandbox000hvnet"
  resource_group = "pdnsadmh-test-eastus2-sandbox-000-rg-000"
}
resolver_vnet = {
  name           = "pdnsadmhtestsandbox000rvnet"
  resource_group = "pdnsadmh-test-eastus2-sandbox-000-rg-000"
}
