provider "azurerm" {
  features {}
}

# resource "azurerm_resource_group" "example" {
#   name     = "aks-resource-group"
#   location = "eastus"
# }

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.rg]
}

# data "azuread_group" "aks_cluster_admins" {
#   name = "${var.prefix}aks-cluster-admins"
# }

module "aks" {
  source                           = "Azure/aks/azurerm"
  resource_group_name              = azurerm_resource_group.rg.name
  #client_id                        = "your-service-principal-client-appid"
  #client_secret                    = "your-service-principal-client-password"
  kubernetes_version               = "1.19.3"
  orchestrator_version             = "1.19.3"
  prefix                           = var.prefix
  cluster_name                     = "aks-dev-01"
  network_plugin                   = "azure"
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  os_disk_size_gb                  = 50
  sku_tier                         = "Paid" # defaults to Free
  #enable_role_based_access_control = true
  #rbac_aad_admin_group_object_ids  = [data.azuread_group.aks_cluster_admins.id]
  #rbac_aad_managed                 = true
  private_cluster_enabled          = true # default value
  enable_http_application_routing  = true
  enable_azure_policy              = true
  enable_auto_scaling              = true
  enable_host_encryption           = true
  agents_min_count                 = 1
  agents_max_count                 = 2
  agents_count                     = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                  = 100
  agents_pool_name                 = "exnodepool"
  agents_availability_zones        = ["1", "2"]
  agents_type                      = "VirtualMachineScaleSets"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  enable_ingress_application_gateway = true
  ingress_application_gateway_name = "aks-agw"
  ingress_application_gateway_subnet_cidr = "10.52.1.0/24"

  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  depends_on = [module.network]
}









# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=2.99.0"
#     }
#   }
# }

# # Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {}
# }

# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.resource_group_location
# }

# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = "${var.prefix}aks-dev-01"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   dns_prefix          = "${var.prefix}aks-dns"

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_D2_v2"
#   }
#    identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     Environment = "Dev"
#   }
# }
# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.aks.kube_config_raw

#   sensitive = true
# }


/* resource "azurerm_app_service_plan" "example" {
  name                = "${var.prefix}app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
} */

/* resource "azurerm_app_service" "example" {
  name                = "${var.prefix}app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
} */