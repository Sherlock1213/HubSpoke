


resource "azurerm_virtual_network" "hubnetwork" {
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.main.location
  name                = "hubnetwork"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "hub-mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  address_prefixes       = ["10.1.3.0/24"]
}

resource "azurerm_subnet" "hub-dmz" {
  name                 = "hub-dmz"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  address_prefixes       = ["10.1.4.0/24"]
}

#check
resource "azurerm_network_interface" "hub-nic" {
  name                 = "hub-nic"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "intern"
    subnet_id                     = azurerm_subnet.hub-mgmt.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "hub"
  }
}
#check 1vm
resource "azurerm_windows_virtual_machine" "hub-vm" {
  name                = "hubvm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.hub-nic.id,
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


resource "azurerm_subnet" "gateway_subnet_hub" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  address_prefixes     = ["10.1.5.0/24"]
}

# Virtual Network Gateway
resource "azurerm_public_ip" "hub-vpn-gateway1-pip" {
  name                = "hub-vpn-gateway1-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Dynamic"
}



resource "azurerm_virtual_network_gateway" "hub-vnet-gateway" {
  name                = "hub-vpn-gateway1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub-vpn-gateway1-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet_hub.id
  }
  depends_on = [azurerm_public_ip.hub-vpn-gateway1-pip]
}

resource "azurerm_virtual_network_gateway_connection" "hub-onprem-conn" {
  name                = "hub-onprem-conn"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  type           = "Vnet2Vnet"
  routing_weight = 1

  virtual_network_gateway_id      = azurerm_virtual_network_gateway.hub-vnet-gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.OnPrem-vnet-gateway.id

  shared_key = "TopG"
}