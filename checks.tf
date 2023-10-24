check "health_check" {
  data "http" "terraform_io" {
    url = "https://www.terraform.io"
  }
  assert {
    condition = data.http.terraform_io.status_code == 200
    error_message = "${data.http.terraform_io.url} returned an unhealthy status code"
  }
}


check "check_vm_state" {
  data "azurerm_virtual_machine" "linux_vm" {
  name                = module.virtual-machine.vm_name
  resource_group_name = azurerm_resource_group.rg.name
}
  assert {
    condition = data.azurerm_virtual_machine.linux_vm.power_state == "running"
    error_message = format("Virtual Machine (%s) should be in a 'running' status, instead state is '%s'",
      data.azurerm_virtual_machine.linux_vm.id,
      data.azurerm_virtual_machine.linux_vm.power_state
    )
  }
}