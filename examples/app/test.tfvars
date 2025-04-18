environment    = "sandbox"
location       = "eastus2"
product_family = "pdnsadms"
tags = {
  Environment = "sandbox"
  ManagedBy   = "Terragrunt"
}
storage_subnet = {
  subnet_name    = "pdnsadm-test-eastus2-sandbox-000-stsn-000"
  vnet_name      = "pdnsadm-test-sandbox-000-svnet"
  resource_group = "pdnsadm-test-eastus2-sandbox-000-rg-000"
}
vm_subnet = {
  subnet_name    = "pdnsadm-test-eastus2-sandbox-000-stsn-000"
  vnet_name      = "pdnsadm-test-sandbox-000-svnet"
  resource_group = "pdnsadm-test-eastus2-sandbox-000-rg-000"
}
