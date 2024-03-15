resource "azurerm_firewall_network_rule_collection" "OnPrem_to_Spoke2" {
  name                = "OnPremToSpoke2Rule"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority            = 100
  action              = "Allow"

  rule {
    name                  = "BlockFromOnPremToSpoke2"
    protocols             = ["Any"]
    source_addresses      = ["*"]  # On-Premises IP range
    destination_addresses = ["*"] # Spoke 2 IP range
    destination_ports     = ["*"]
  }
}




resource "azurerm_firewall_network_rule_collection" "spoke2_to_spoke1" {

  name                = "Spoke2toSpoke1Rule"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority            = 110
  action              = "Allow"

  rule {
    name                  = "AllowFromDevToTest"
    protocols             = ["Any"]
    source_addresses      = ["10.3.0.0/16"]
    destination_addresses = ["10.2.0.0/16"]
    destination_ports     = ["*"]
  }
}



/*
resource "azurerm_firewall_network_rule_collection" "spoke1_to_spoke2" {
  name                = "Spoke1toSpoke2"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority            = 120
  action              = "Allow"

  rule {
    name                  = "AllowFromTestToDev"
    protocols             = ["Any"]
    source_addresses      = ["10.2.0.0/16"]
    destination_addresses = ["10.3.0.0/16"]
    destination_ports     = ["*"]
  }
}
*/
#onprem zu vm in Test

resource "azurerm_firewall_network_rule_collection" "OnPrem_to_Spoke1" {
  name                = "OnPremToSpoke1"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority            = 105
  action              = "Allow"

  rule {
    name                  = "AllowFromOnPremToSpoke1"
    protocols             = ["Any"]
    source_addresses      = ["10.4.0.0/16"]
    destination_addresses = ["10.2.0.0/16"]
    destination_ports     = ["*"]
  }
}

#onprem zu vm Dev

/*
resource "azurerm_firewall_network_rule_collection" "OnPrem_to_Spoke2" {
  name                = "OnPremToSpoke2"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority            = 140
  action              = "Allow"

  rule {
    name                  = "AllowFromOnPremToSpoke2"
    protocols             = ["Any"]
    source_addresses      = ["10.4.0.0/16"]
    destination_addresses = ["10.3.0.0/16"]
    destination_ports     = ["*"]
  }
}

*/

# Dev zu vm in Onprem

resource "azurerm_firewall_network_rule_collection" "Spoke2_To_OnPrem" {
  name                = "Spoke2ToOnPrem"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority            = 150
  action              = "Allow"

  rule {
    name                  = "AllowFromDevToOnPrem"
    protocols             = ["Any"]
    source_addresses      = ["10.3.0.0/16"]
    destination_addresses = ["10.4.0.0/16"]
    destination_ports     = ["*"]
  }
}

# Test to OnPrem vm



resource "azurerm_firewall_network_rule_collection" "Spoke1_To_OnPrem" {
  name                = "Spoke1ToOnPrem"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority            = 160
  action              = "Allow"

  rule {
    name                  = "AllowFromTestToOnPrem"
    protocols             = ["Any"]
    source_addresses      = ["10.2.0.0/16"]
    destination_addresses = ["10.4.0.0/16"]
    destination_ports     = ["*"]
  }
}

