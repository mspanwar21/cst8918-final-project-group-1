# Modern Data Platform Project

## Project Overview
This project implements a modern data pipeline architecture using Azure services. The pipeline supports big data processing, real-time event ingestion, AI-powered analytics, and automated deployment.

## Team Members
- [Mohit Singh Panwar](https://github.com/mspanwar21)
- [Ololademodin Akinrinsola](https://github.com/ololadeakin)
- [ Jonathanaded Martins](https://github.com/dejalltime)

## Professor
- [Prof. Rick McKenney](https://github.com/rlmckenney)

# README – Terraform AKS Lab Deployment

## Overview

This project implements a modular **Terraform** setup for deploying Azure infrastructure including:

* **Backend bootstrap** for remote state storage.
* Separate **test** and **prod** environment configurations.
* Modular deployment of **networking**, **AKS**, **Redis**, and **ACR**.
* **Subnet configuration** for multiple environments in a single virtual network.

The goal was to follow Infrastructure as Code (IaC) best practices, support multiple environments, and meet Azure's networking requirements for AKS.

---

## Project Structure

```
/infra
  /bootstrap-backend
  /env
    /test
    /prod
  /modules
    /network
    /aks
    /redis
    /acr
```
## Steps Completed

1. **GitHub Setup**

   * Created a new GitHub account.
   * Set up a new repository for the lab project.
   * Cloned the repository locally and connected it to our development environment.
   * Created and switched to feature branches for making changes, following the GitHub Flow process.

2. **Terraform Initialization**

   * Installed Terraform locally.
   * Initialized Terraform in the project directory.
   * Created the main Terraform configuration files for Azure resources.

3. **Azure Resource Creation**

   * Configured Terraform to use the Azure provider.
   * Created a resource group, virtual network, and multiple subnets.
   * Used variables and outputs to make the configuration reusable.

4. **Subnet Configuration**

   * Defined multiple subnets with CIDR blocks.
   * Ensured subnet ranges did not overlap.
   * Understood that subnets are logical subdivisions of a virtual network, each with its own range of IP addresses for resources.

5. **Deployment**

   * Used `terraform plan` to preview changes.
   * Applied changes with `terraform apply` to provision Azure resources.

### 1. **Bootstrap Backend Folder**

* Purpose: Creates the **Azure Resource Group**, **Storage Account**, and **Blob Container** for Terraform remote state.
* This is run **once** before deploying any environment to ensure Terraform can store state remotely.

Commands:

```bash
cd bootstrap-backend
terraform init
terraform apply
```

### 2. **Environment Folders (test & prod)**

* Each environment has its own variables (`variables.tf`) defining:

  * `location`
  * `resource_group_name` (shared in our setup)
  * `env`
  * `node_count`
  * Networking CIDRs and names
  * API keys or sensitive values
* Each environment calls the modules with its own parameters.

Example for **prod**:

```hcl
module "network" {
  source              = "../../modules/network"
  location            = var.location
  resource_group_name = var.resource_group_name
  env                 = var.env
}
```

Commands:

```bash
cd env/prod
terraform init
terraform apply
```

### 3. **Modules Folder**

* **network**: Creates VNet and subnets.
* **aks**: Provisions Kubernetes cluster.
* **redis**: Creates Azure Redis Cache.
* **acr**: Deploys Azure Container Registry.

Each module is reusable and parameterized.

---

## Subnet Configuration

The `network` module provisions **one Virtual Network** with **four subnets**:

```hcl
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
```

### How it works:

* **`count = 4`** creates four subnets.
* **Subnet names**: `prod`, `test`, `dev`, `admin` (picked from the list by `count.index`).
* **`cidrsubnet()`** automatically splits `10.0.0.0/14` into 4 equal subnets.

  * Index `0` → `prod`
  * Index `1` → `test`
  * Index `2` → `dev`
  * Index `3` → `admin`

This allows **one VNet** to be shared across environments, but keeps resources isolated by subnet.

---

## Challenges & Solutions

1. **Subnet restrictions with AKS**

   * AKS requires that the target subnet has no NSG blocking required ports.
   * Solution: Created subnets without NSGs initially and allowed AKS to manage its own rules.

2. **CIDR planning**

   * Initial overlapping address spaces caused conflicts.
   * Solution: Used `cidrsubnet()` to ensure automatic non-overlapping subnets.

3. **Environment-specific resources**

   * Needed to deploy test and prod into **different subnets** but the same VNet.
   * Solution: Parameterized `env` and subnet naming in the module.

---

## Deployment Order

1. **Bootstrap backend**

```bash
cd bootstrap-backend
terraform init
terraform apply
```

2. **Deploy environment** (e.g., prod)

```bash
cd env/prod
terraform init
terraform apply
```

This will create:

* Networking (VNet + subnets)
* AKS cluster
* Redis
* ACR

---

## Key Takeaways

* **Single resource group, multiple environments** is possible by using subnet isolation.
* `cidrsubnet()` is a powerful tool for dynamically splitting address spaces.
* Keep backend state storage separate from application resources.
