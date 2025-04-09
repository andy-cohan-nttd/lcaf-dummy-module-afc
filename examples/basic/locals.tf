locals {
  resource_names = toset([
    "cds",
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
    "pip",
    "policy",
    "rg",
    "rt",
    "sa",
    "sn",
    "sp",
    "vnet",
  ])
  product_family = "pdnsadm"
}
