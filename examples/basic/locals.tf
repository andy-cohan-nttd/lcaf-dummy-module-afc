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
}
