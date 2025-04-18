locals {
  resource_names = toset([
    "cds",
    "fa",
    "fp",
    "fprcgn",
    "mgmtgrp",
    "nsg",
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
    "sa",
    "ibsn",
    "obsn",
    "stpe",
    "stsn",
    "sp",
    "vm",
    # "hvnet",
    # "svnet",
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
}
