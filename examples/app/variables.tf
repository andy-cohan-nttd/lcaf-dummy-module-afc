variable "environment" {
  description = "Environment name e.g. sandbox"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created. This should be a valid Azure region."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "product_family" {
  description = "The product family for the resources, used for naming conventions."
  type        = string
}

variable "storage_subnet" {
  description = "Storage subnet configuration"
  type = object({
    subnet_name    = string
    vnet_name      = string
    resource_group = string
  })
}

variable "vm_subnet" {
  description = "VM subnet configuration"
  type = object({
    subnet_name    = string
    vnet_name      = string
    resource_group = string
  })
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for VM access"
  type        = string
  default     = "~/.ssh/id_lcaf.pub"
}
