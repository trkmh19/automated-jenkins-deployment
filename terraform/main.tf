resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "this" {
  name                = "jenkins_nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_jenkins_ui"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_jenkins_slave"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "50000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "jenkins_vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = "jenkins_subnet"
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.this.name
}

resource "azurerm_subnet_network_security_group_association" "jenkins_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_public_ip" "this" {
  name                = "jenkins_public_ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "this" {
  name                = "jenkins_nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "jenkinsVm"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = "tarek"
    public_key = file(var.public_key_path)
  }

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    name                 = "jenkins_os_disk"
    caching              = "None"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "30"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}
