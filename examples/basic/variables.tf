variable "environment" {
  description = "Environment name e.g. sandbox"
  type        = string
}

variable "region" {
  description = "The Azure region where resources will be created. This should be a valid Azure region."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
}
