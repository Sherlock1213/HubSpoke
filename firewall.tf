resource "azurerm_public_ip" "firewall" {
  name                = "firewallPublicIP"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "main" {
  name                = "hubFirewall"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet_hub.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
}

resource "azurerm_subnet" "firewall_subnet_hub" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  address_prefixes     = ["10.1.2.0/26"]
}

