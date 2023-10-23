provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "4.1.0"
  vnet_location       = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  use_for_each        = true
  vnet_name           = "${var.prefix}-${var.vnet_name}"
  subnet_names        = ["subnet1"]
  subnet_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-vm-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

# resource "azurerm_public_ip" "public_ip2" {
#   name                = "${var.prefix}-vm-public-ip2"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
# }

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-linux-vm-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "allow_http_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = module.virtual-machine.network_interface_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

module "virtual-machine" {
  source              = "Azure/virtual-machine/azurerm"
  version             = "1.0.0"
  image_os            = "linux"
  os_simple           = "UbuntuServer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "${var.prefix}-linux-vm"
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  size      = "Standard_F2"
  #size = "Standard_D2_v2"
  subnet_id = module.vnet.vnet_subnets[0]
  new_network_interface = {
    ip_forwarding_enabled = false
    name                  = "${var.prefix}-linux-vm-nic"
    ip_configurations = [
      {
        public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
        subnet_id                     = module.vnet.vnet_subnets[0]
        private_ip_address_allocation = "Dynamic"
        primary                       = true
      }
    ]
  }
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = "false"
}





