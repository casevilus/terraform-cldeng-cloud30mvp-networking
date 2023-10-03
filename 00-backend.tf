terraform {
  required_version = "1.5.7"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.75.0"
    }

  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "CADENCE_TEST"

    workspaces {
      prefix = "cloudmvp-networking-"
    }
  }
}
