module "private_dns_policy" {
  source = "../../"

  name = module.resource_names["policy"].standard
  # location         = var.location
  display_name     = "Private DNS Policies"
  management_group = module.management_group.management_group
}
