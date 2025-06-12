output "resource_group_name" {
  value = azurerm_resource_group.my_resource_group.name
}

output "public_ip_address" {
  value = module.vm_demo.public_ip_address
}