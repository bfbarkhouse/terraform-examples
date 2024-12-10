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
      version = "4.13.0"
    }
  }
}
