
locals {
  spoke2-location       = "westeurope"
  spoke2-resource-group = "spoke2-vnet-rg"
  prefix-spoke2         = "spoke2"
}

resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = "Spoke2"
  location = "westeurope"
}









resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "spoke2-vnet"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
}

resource "azurerm_subnet" "spoke2-mgmt" {
  address_prefixes     = ["10.3.1.0/24"]
  name                 = "spoke2mgmt"
  resource_group_name  = azurerm_resource_group.spoke2-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name

}






resource "azurerm_network_interface" "spoke2-nic" {
  name                 = "Spoke2nic"
  location             = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name  = azurerm_resource_group.spoke2-vnet-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "spoke2"
    subnet_id                     = azurerm_subnet.spoke2-mgmt.id
    private_ip_address_allocation = "Dynamic"

  }

  tags = {
    environment = "spoke2"
  }
}

resource "azurerm_public_ip" "spoke2_vm_pub" {
  name                = "spoke2vmpub"
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_windows_virtual_machine" "devvm" {
  name                = "devvm"
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.spoke2-nic.id,
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