provider "azurerm" {
  features {}
}

module "network" {
  source              = "../../modules/network"
  location            = var.location
  resource_group_name = var.resource_group_name
  env                 = var.env
}

module "aks" {
  source              = "../../modules/aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  node_count          = var.node_count
  kubernetes_version  = "1.32.0"
  env                 = var.env
}

module "redis" {
  source              = "../../modules/redis"
  location            = var.location
  resource_group_name = var.resource_group_name
  env                 = var.env
}

module "acr" {
  source              = "../../modules/acr"
  location            = var.location
  resource_group_name = var.resource_group_name
  env                 = var.env
}
