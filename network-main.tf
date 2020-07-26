####################
## Network - Main ##
####################

# Create a resource group for network
resource "azurerm_resource_group" "network-rg" {
  name     = "gitlab-rg"
  location = "francecentral"

}

# Create the network VNET
resource "azurerm_virtual_network" "network-vnet" {
  name                = "gitlab-vnet"
  address_space       = [var.network-vnet-cidr]
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location

}

# Create a subnet for Network
resource "azurerm_subnet" "network-subnet" {
  name                 = "gitlab-subnet"
  address_prefix       = var.network-subnet-cidr
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name
}

