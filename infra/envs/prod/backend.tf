terraform {
  required_version = ">= 1.6.0"
  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-group-1"
    storage_account_name = "cst8918finalprojgrp1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
