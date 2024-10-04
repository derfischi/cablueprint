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

  backend "azurerm" {
    resource_group_name  = "p-vw-tfstate-weu-rg"
    storage_account_name = "vwpcoretfstateweust"
    container_name       = "entra-ca-policy"
    key                  = "prod.terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {

  }
  tenant_id = var.entra_tenant_id
}

provider "azuread" {
  tenant_id = var.entra_tenant_id
}
