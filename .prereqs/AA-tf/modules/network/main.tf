resource "azurerm_public_ip" "my_public_ip" {
  name                = "${var.workload_nickname}PublicIp"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_nsg" {
  name                = "${var.workload_nickname}Nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "${var.workload_nickname}Vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "${var.workload_nickname}Subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "my_nic" {
  name                = "${var.workload_nickname}Nic"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "${var.workload_nickname}_nic_configuration"
    subnet_id                     = azurerm_subnet.my_subnet.id
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

