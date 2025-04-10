module "private_dns_policy" {
  source = "../../"

  management_group    = module.management_group.management_group
  policy_name         = module.resource_names["policy"].minimal_random_suffix
  policy_display_name = "Private Endpoint DNS Policy"
  # subnetId = module.outbound_dns_subnet.subnet.id
}
