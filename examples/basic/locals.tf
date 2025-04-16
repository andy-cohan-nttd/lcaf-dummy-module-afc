locals {
  resource_names = toset([
    "cds",
    "deployer",
    "fa",
    "fp",
    "fprcgn",
    "hubvnet",
    "hubvnip",
    "mgmtgrp",
    "nsg",
    "pdnsr",
    "pdnsrfr",
    "pdnsroep",
    "pdnsrvnl",
    "pdzvnl",
    "pip",
    "policy",
    "rg",
    "rt",
    "sa",
    "sn",
    "sp",
    "vm",
    "vneth",
    "vnets",
  ])
  product_family = "pdnsadm"

  azure_private_zones = [
    "afs.azure.net",
    "blob.core.windows.net",
    "dfs.core.windows.net",
    "file.core.windows.net",
    "queue.core.windows.net",
    "table.core.windows.net",
    "web.core.windows.net"
  ]
}
