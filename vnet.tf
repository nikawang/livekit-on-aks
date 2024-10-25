

resource "azurerm_resource_group" "rg" {
  name     = "livekit-${var.region}"
  location = var.region
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.region}"
  address_space       = ["${var.ip-prefix}.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet" "privatelinksubnet" {
  name                 = "PrivateLinkSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["${var.ip-prefix}.1.0/24"]
}

resource "azurerm_subnet" "aks-subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["${var.ip-prefix}.2.0/24"]
}
