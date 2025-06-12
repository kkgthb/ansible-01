resource "azurerm_resource_group" "my_resource_group" {
  provider = azurerm.demo
  name     = "${var.workload_nickname}-rg-demo"
  location = "centralus"
}

module "ssh_keys_demo" {
  source = "./modules/ssh"
  providers = {
    azurerm = azurerm.demo
    azapi = azapi.demo
  }
  resource_group = {
    id       = azurerm_resource_group.my_resource_group.id
    location = azurerm_resource_group.my_resource_group.location
  }
}

module "network_demo" {
  source = "./modules/network"
  providers = {
    azurerm = azurerm.demo
  }
  resource_group = {
    id       = azurerm_resource_group.my_resource_group.id
    name     = azurerm_resource_group.my_resource_group.name
    location = azurerm_resource_group.my_resource_group.location
  }
  workload_nickname = var.workload_nickname
}

module "vm_demo" {
  source = "./modules/vm"
  providers = {
    azurerm = azurerm.demo
  }
  resource_group = {
    id       = azurerm_resource_group.my_resource_group.id
    name     = azurerm_resource_group.my_resource_group.name
    location = azurerm_resource_group.my_resource_group.location
  }
  nic_id                           = module.network_demo.nic_id
  username                         = "foobar"
  azapi_resource_action_public_key = module.ssh_keys_demo.key_data
  workload_nickname                = var.workload_nickname
}
