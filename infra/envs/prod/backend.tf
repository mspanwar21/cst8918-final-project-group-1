terraform {
  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-group-1"
    storage_account_name = "iacstoragegroup1"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
