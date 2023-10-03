variable "location" {
  type        = string
  description = "(Required) The location where the resource group should be created. For a list of all Azure locations, please run az account list-locations --output table."
}

variable "subdomain" {
  type        = string
  description = "(Optional) Subdomain of Domain."
  default     = null
}

variable "vnet_address_space" {
  type        = string
  description = "(Required) The address space that is used by the virtual network."
}

variable "subnet_newbits" {
  type        = string
  description = "(Optional) The number of additional bits with which to extend the VNet prefix for subnets."
  default     = 5
}

variable "tags" {
  type        = string
  description = "(Optional) A map of the tags to use on the resources that are deployed with this module."
}

