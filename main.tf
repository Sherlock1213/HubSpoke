# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }


  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  /*client_id       = "6726c50a-0aa4-4f1d-9646-710eba7c7628"
  client_secret   = var.client_secret
  tenant_id       = "d4b72ec1-987c-4f50-ae1a-3c8674481f1c"
  subscription_id = "b94f7f22-6db5-4f37-bc3b-2ff2110f9918"*/
}

resource "azurerm_resource_group" "main" {
  name     = "mainnetwork"
  location = "westeurope"
}



resource "azurerm_virtual_network_peering" "spoke2-to-hub-peer" {
  name                      = "spoke2tohub"
  resource_group_name       = azurerm_resource_group.spoke2-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke2-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hubnetwork.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = true
  depends_on = [azurerm_virtual_network.spoke2-vnet, azurerm_virtual_network.hubnetwork, azurerm_virtual_network_gateway.hub-vnet-gateway]


}


resource "azurerm_virtual_network_peering" "hub-to-spoke2-peer" {
  name                      = "HubToSpoke2"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.hubnetwork.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit   = true
  depends_on = [azurerm_virtual_network.spoke2-vnet, azurerm_virtual_network.hubnetwork, azurerm_virtual_network_gateway.hub-vnet-gateway]

}




resource "azurerm_virtual_network_peering" "Spoke1-to-hub-peer" {
  name                      = "Spoke1ToHub"
  resource_group_name       = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke1-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hubnetwork.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = true
  depends_on = [azurerm_virtual_network.spoke1-vnet, azurerm_virtual_network.hubnetwork, azurerm_virtual_network_gateway.hub-vnet-gateway]

}


resource "azurerm_virtual_network_peering" "hub-to-Spoke1-peer" {
  name                      = "HubToSpoke1"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.hubnetwork.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit   = true

  depends_on = [azurerm_virtual_network.spoke1-vnet, azurerm_virtual_network.hubnetwork, azurerm_virtual_network_gateway.hub-vnet-gateway]
}
