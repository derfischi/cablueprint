terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "<RESOURCE_GROUP_NAME>"
  #   storage_account_name = "<STORAGE_ACCOUNT_NAME>"
  #   container_name       = "entra-ca-policy"
  #   key                  = "terraform.tfstate"
  #   use_azuread_auth     = true
  # }
}

provider "azurerm" {
  features {}
  tenant_id = var.entra_tenant_id
}

provider "azuread" {
  tenant_id = var.entra_tenant_id
}
