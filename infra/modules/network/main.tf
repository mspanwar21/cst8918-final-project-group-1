variable "resource_group_name" {}
variable "location" {}
variable "env" {}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.env}"
  address_space       = ["10.0.0.0/14"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnets" {
  count                = 4
  name                 = ["prod", "test", "dev", "admin"][count.index]
  address_prefixes     = [cidrsubnet("10.0.0.0/14", 2, count.index)]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
}
