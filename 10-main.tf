data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

# https://github.com/hashicorp/terraform/issues/22802#issuecomment-573852518
variable "TFC_WORKSPACE_NAME" {
  type    = string
  default = "" # An error occurs when you are running TF backend other than Terraform Cloud
}

locals {
  # If the backend is Terraform Cloud, the value is TFC_WORKSPACE_NAME without the prefix, otherwise it's ${terraform.workspace}
  workspace_name = coalesce(trimprefix(var.TFC_WORKSPACE_NAME, "cloudmvp-networking-"), terraform.workspace)
  prefix         = "cloudmvp-${local.workspace_name}"

  common_tags = {
    Workspace = local.workspace_name
    Project   = "cloudmvp"
  }

  rg_name                 = "${local.prefix}-rg"
  vnet_name               = "${local.prefix}-vnet"
  pip_name                = "${local.prefix}-pio"
  subdomain               = var.subdomain == null ? local.workspace_name : jsondecode(var.subdomain)
  tags                    = merge(local.common_tags, jsondecode(var.tags))
}


module "resource_group" {
  source  = "app.terraform.io/CADENCE_TEST/resource-group/azurerm"
  version = "0.0.1"

  name     = local.rg_name
  location = jsondecode(var.location)
  tags     = local.tags
}


module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = jsondecode(var.vnet_address_space)
  networks = [
    {
      name     = null
      new_bits = 8
    },
    {
      name     = "bastion"
      new_bits = 11
    },
    {
      name     = null
      new_bits = 9
    },
    {
      name     = "gateway"
      new_bits = 11
    },
    {
      name     = "management"
      new_bits = 8
    },
    {
      name     = "aks"
      new_bits = 5
    },
    {
      name     = "postgres"
      new_bits = 6
    }
  ]
}

module "vnet" {
  source  = "app.terraform.io/CADENCE_TEST/vnet/azurerm"
  version = "0.0.1"

  name                    = local.vnet_name
  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location
  address_space           = jsondecode(var.vnet_address_space)
  create_ddos_plan        = false
  ddos_protection_plan_id = null
  subnets = [
    {
      name     = "aks"
      cidr     = lookup(module.subnet_addrs.network_cidr_blocks, "aks")
      services = ["Microsoft.Storage"]
    }
  ]

  tags = local.tags
}


module "pip" {
  source  = "app.terraform.io/CADENCE_TEST/public-ip/azurerm"
  version = "0.0.2"

  name                = local.pip_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Dynamic"
  sku                 = "Standard"
  tags                = local.tags
}
