provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"
  # insert the 3 required variables here
  vnet_location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  use_for_each = true

}

module "virtual-machine" {
  source  = "Azure/virtual-machine/azurerm"
  version = "1.0.0"
  # insert the 7 required variables here
  image_os = "linux"
  os_simple = "UbuntuServer"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name = "${var.prefix}-linux-vm"
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  size = "Standard_F2"
  subnet_id = module.vnet.vnet_subnets[0]
  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = "false"
}





