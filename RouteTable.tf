



resource "azurerm_route_table" "hub_to_spokes_via_firewall" {
  name                = "routeHubToSpokesViaFirewall"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name


  # Route für Spoke1 durch Azure Firewall
  route {
    name                   = "routeToSpoke1ViaFirewall"
    address_prefix         = "10.2.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  }

  # Route für Spoke2 durch Azure Firewall
  route {
    name                   = "routeToSpoke2ViaFirewall"
    address_prefix         = "10.3.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  }



}
resource "azurerm_subnet_route_table_association" "gateway_subnet_route_table_assoc" {
  subnet_id      = azurerm_subnet.gateway_subnet_hub.id
  route_table_id = azurerm_route_table.hub_to_spokes_via_firewall.id
}


resource "azurerm_route_table" "spoke1-rt" {
  name                          = "spoke1-rt"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name

  route {
    name                   = "toSpoke2"
    address_prefix         = "10.3.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  }

}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-mgmt" {
  subnet_id      = azurerm_subnet.spoke1-mgmt.id
  route_table_id = azurerm_route_table.spoke1-rt.id
  depends_on = [azurerm_subnet.spoke1-mgmt]
}




resource "azurerm_route_table" "spoke2-rt" {
  name                          = "spoke2-rt"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name


  route {
    name                   = "toSpoke1"
    address_prefix         = "10.2.0.0/16"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
    next_hop_type          = "VirtualAppliance"
  }


}

resource "azurerm_subnet_route_table_association" "spoke2-rt-spoke2-vnet-mgmt" {
  subnet_id      = azurerm_subnet.spoke2-mgmt.id
  route_table_id = azurerm_route_table.spoke2-rt.id
  depends_on = [azurerm_subnet.spoke2-mgmt]
}
