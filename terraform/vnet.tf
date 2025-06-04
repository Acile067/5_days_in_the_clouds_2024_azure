resource azurerm_virtual_network main {
  name                = "vnet-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

# Create subnets for the virtual network PE
resource azurerm_subnet snet_pe {
  name                              = "snet-${var.application_name}-pe-${var.environment_name}-${var.location_short}-${var.resource_version}"
  resource_group_name               = azurerm_resource_group.main.name
  virtual_network_name              = azurerm_virtual_network.main.name
  address_prefixes                  = ["10.0.4.0/24"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

resource azurerm_subnet_network_security_group_association snet_pe_nsg_association {
  subnet_id                 = azurerm_subnet.snet_pe.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Create subnets for the virtual network Backend
resource azurerm_subnet snet_backend {
  name                              = "snet-${var.application_name}-be-${var.environment_name}-${var.location_short}-${var.resource_version}"
  resource_group_name               = azurerm_resource_group.main.name
  virtual_network_name              = azurerm_virtual_network.main.name
  address_prefixes                  = ["10.0.5.0/24"]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource azurerm_app_service_virtual_network_swift_connection be_vni {
  app_service_id  = azurerm_linux_web_app.backend.id
  subnet_id       = azurerm_subnet.snet_backend.id
}

resource azurerm_subnet_network_security_group_association snet_backend_nsg_association {
  subnet_id                 = azurerm_subnet.snet_backend.id
  network_security_group_id = azurerm_network_security_group.main.id
}
