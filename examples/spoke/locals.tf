locals {
  resource_names = toset([
    "nsg",
    "rg",
    "pdzvnps",
    "stsn",
    "svnet",
  ])
}
