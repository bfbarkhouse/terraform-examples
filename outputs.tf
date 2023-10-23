output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "vm_identity_type" {
    value = module.virtual-machine.vm_identity["type"]
}