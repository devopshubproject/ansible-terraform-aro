##### Outputs #####

output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = "${azurerm_virtual_network.vnet.id}"
}

output "vnet_subnets" {
  description = "The ids of subnets created inside the vNet"
  value       = "${azurerm_subnet.subnet["${var.environment}-bastion-snet"].id}"
}