locals {
  resource_names = toset([
    "cds",
    "deployer",
    "fa",
    "fp",
    "fprcgn",
    "hvnet",
    "ibsn",
    "mgmtgrp",
    "nsg",
    "obsn",
    "pdnsr",
    "pdnsrfr",
    "pdnsrie",
    "pdnsriep",
    "pdnsroep",
    "pdnsrvnl",
    "pdzvnl",
    "pip",
    "policy",
    "rg",
    "rt",
    "rvnet",
    "sp",
    "stpe",
    "stsn",
    "svnet",
  ])

  azure_private_zones = [
    "afs.azure.net",
    "blob.core.windows.net",
    "dfs.core.windows.net",
    "file.core.windows.net",
    "queue.core.windows.net",
    "table.core.windows.net",
    "web.core.windows.net"
  ]
  deployment_identity_name = module.resource_names["deployer"].minimal_random_suffix
}
