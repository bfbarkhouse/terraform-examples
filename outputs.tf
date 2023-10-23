output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "vm_identity" {
    value = module.virtual-machine.azurerm_linux_virtual_machine.vm_linux.identity
}