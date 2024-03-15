resource "azurerm_resource_group" "onprem" {
  name     = "onpremnetwork"
  location = "westeurope"
}

resource "azurerm_virtual_network" "onprem-vnet" {
  name                = "onprem-vnet"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  address_space       = ["10.4.0.0/16"]
}

resource "azurerm_subnet" "onprem-mgmt" {
  address_prefixes     = ["10.4.1.0/24"]
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
}

resource "azurerm_subnet" "onprem-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes     = ["10.4.2.0/24"]
}

resource "azurerm_public_ip" "onprem-vpn-gateway1-pip" {
  name                = "onprem-vpn-gateway1-pip"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  allocation_method = "Dynamic"
}


resource "azurerm_virtual_network_gateway" "OnPrem-vnet-gateway" {
  name                = "hub-vpn-gateway1"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub-vpn-gateway1-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem-gateway-subnet.id
  }
  depends_on = [azurerm_public_ip.hub-vpn-gateway1-pip]
}

resource "azurerm_virtual_network_gateway_connection" "Onprem-Hub-conn" {
  name                = "hub-onprem-conn"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type           = "Vnet2Vnet"
  routing_weight = 1

  virtual_network_gateway_id      = azurerm_virtual_network_gateway.OnPrem-vnet-gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.hub-vnet-gateway.id

  shared_key = "TopG"
}




resource "azurerm_windows_virtual_machine" "vm_onprem" {
  name                = "vmonprem"
  resource_group_name = azurerm_resource_group.onprem.name
  location            = azurerm_resource_group.onprem.location
  size                = "Standard_DS1_v2"

  network_interface_ids = [azurerm_network_interface.onprem-nic.id]

  admin_username = "adminuser"
  admin_password = "P@$$w0rd123!"
  computer_name  = "vmonpremHost"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "onprem-nic" {
  name                = "thisNIConprem"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.onprem-mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.onprem-pip.id
  }
}


resource "azurerm_public_ip" "onprem-pip" {
  name                = "onpremPublicIP"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "onprem"
  }
}
