environment    = "sandbox"
location       = "eastus2"
product_family = "pdnsadma"
tags = {
  Environment = "sandbox"
  ManagedBy   = "Terragrunt"
}
app_subnet = {
  subnet_name    = "pdnsadms-test-eastus2-sandbox-000-stsn-000"
  vnet_name      = "pdnsadmstestsandbox000svnet"
  resource_group = "pdnsadms-test-eastus2-sandbox-000-rg-000"
}
ssh_public_key_path = "~/.ssh/id_lcaf.pub"
