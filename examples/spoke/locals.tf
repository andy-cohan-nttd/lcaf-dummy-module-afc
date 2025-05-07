locals {
  resource_names = toset([
    "nsg",
    "rg",
    "pdzvnps",
    "stsn",
    "svnet",
  ])
  azure_private_zones = [
    "blob.core.windows.net",
    "vaultcore.azure.net"
    # "afs.azure.net",
    # "dfs.core.windows.net",
    # "file.core.windows.net",
    # "queue.core.windows.net",
    # "table.core.windows.net",
    # "web.core.windows.net",
  ]
}
