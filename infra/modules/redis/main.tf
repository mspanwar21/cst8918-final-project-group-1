variable "resource_group_name" {}
variable "location" {}
variable "env" {}

resource "azurerm_redis_cache" "cache" {
  name                = "redis-CST8918-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 1
  family              = "C"
  sku_name            = "Basic"
}
