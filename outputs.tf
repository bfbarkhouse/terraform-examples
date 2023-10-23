output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "vm_admin_username" {
    value = module.virtual-machine.vm_admin_username
}