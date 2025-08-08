variable "resource_group_name" {}
variable "location" {}
variable "env" {}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}
