terraform {
  cloud {
    organization = "bbarkhouse-training"
    hostname     = "app.terraform.io"
    workspaces {
      name    = "tf-demo"
      project = "tf-demo"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.76.0"
    }
  }
}
provider "azurerm" {
  # Configuration options
}
