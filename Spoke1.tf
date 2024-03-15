

locals {
  spoke1-location       = "westeurope"
  spoke1-resource-group = "spoke1-vnet-rg"
  prefix-spoke1         = "spoke1"
}

resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = "spoke1"
  location = "westeurope"
}

resource "azurerm_virtual_network" "spoke1-vnet" {
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  name                = "testnetwork"
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
}

resource "azurerm_subnet" "spoke1-mgmt" {
  address_prefixes     = ["10.2.2.0/24"]
  name                 = "spoke1"
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
}




resource "azurerm_network_interface" "Spoke1nic" {
  name                = "Spoke1nic"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name

  ip_configuration {
    name                          = "spoke1"
    subnet_id                     = azurerm_subnet.spoke1-mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spoke1_ip.id
  }

  tags = {
    environment = "spoke1"
  }

  }
resource "azurerm_public_ip" "spoke1_ip" {
    name                = "Spoke1PublicIP"
    location            = azurerm_resource_group.spoke1-vnet-rg.location
    resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
    allocation_method   = "Dynamic"
    sku                 = "Basic"

  }



resource "azurerm_windows_virtual_machine" "spoke1vm" {
  name                = "spoke1vm"
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.Spoke1nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}