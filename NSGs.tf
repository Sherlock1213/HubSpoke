# Create Network Security Group and rule
/*
resource "azurerm_network_security_group" "onprem-nsg" {
  name                = "nsg-OnPrem"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "onprem"
  }
}

resource "azurerm_subnet_network_security_group_association" "OnPrem-NSG" {
  subnet_id                 = azurerm_subnet.onprem-mgmt.id
  network_security_group_id = azurerm_network_security_group.onprem-nsg.id
}


# Create Network Security Group and rule  HUB
resource "azurerm_network_security_group" "Hub-nsg" {
  name                = "nsg-Hub"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Hub"
  }
}

resource "azurerm_subnet_network_security_group_association" "Hub-NSG" {
  subnet_id                 = azurerm_subnet.hub-mgmt.id
  network_security_group_id = azurerm_network_security_group.Hub-nsg.id
}

# Create Network Security Group and rule  Spoke1
resource "azurerm_network_security_group" "Spoke1-nsg" {
  name                = "nsg-Spoke1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Spoke1"
  }
}

resource "azurerm_subnet_network_security_group_association" "Spoke1-NSG" {
  subnet_id                 = azurerm_subnet.spoke1-mgmt.id
  network_security_group_id = azurerm_network_security_group.Spoke1-nsg.id
}

# Create Network Security Group and rule Spoke2
resource "azurerm_network_security_group" "Spoke2-nsg" {
  name                = "nsg-Spoke2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Spoke2"
  }
}

resource "azurerm_subnet_network_security_group_association" "Spoke2-NSG" {
  subnet_id                 = azurerm_subnet.spoke2-mgmt.id
  network_security_group_id = azurerm_network_security_group.Spoke2-nsg.id
}
*/