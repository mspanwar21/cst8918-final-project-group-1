variable "resource_group_name" {}
variable "location" {}
variable "node_count" {}
variable "kubernetes_version" {}
variable "env" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.env}"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = var.kubernetes_version
}
