resource "azurerm_resource_group" "my_resource_group" {
  provider = azurerm.demo
  name     = "${var.workload_nickname}-rg-demo"
  location = "centralus"
}

module "ssh_keys_demo" {
  source = "./modules/ssh"
  providers = {
    azurerm = azurerm.demo
  }
  resource_group = {
    id       = azurerm_resource_group.my_resource_group.id
    location = azurerm_resource_group.my_resource_group.location
  }
}
