resource azurerm_network_security_group main {
  name                = "nsg-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource azurerm_network_security_rule deny_all_inbound {
  name                        = "deny-all-inbound"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  depends_on = [azurerm_network_security_group.main]
}

# Create a rule to allow inbound traffic from the backend subnet to the private endpoint subnet
resource azurerm_network_security_rule be-pe {
  name                        = "nsgsr-${var.application_name}-be-pe-${var.environment_name}-${var.location_short}-${var.resource_version}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" 
  destination_port_range      = "*" 
  source_address_prefix       = "10.0.5.0/24"
  destination_address_prefix  = "10.0.4.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  depends_on = [azurerm_network_security_group.main]
}

resource azurerm_network_security_rule pe-be {
  name                        = "nsgsr-${var.application_name}-pe-be-${var.environment_name}-${var.location_short}-${var.resource_version}"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" 
  destination_port_range      = "*"
  source_address_prefix       = "10.0.4.0/24"
  destination_address_prefix  = "10.0.5.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  depends_on = [azurerm_network_security_group.main]
}

resource azurerm_network_security_rule pe-agw {
  name                        = "nsgsr-${var.application_name}-pe-agw-${var.environment_name}-${var.location_short}-${var.resource_version}"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" 
  destination_port_range      = "*"
  source_address_prefix       = "10.0.4.0/24"
  destination_address_prefix  = "10.0.2.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  depends_on = [azurerm_network_security_group.main]
}

resource azurerm_network_security_rule agw-pe {
  name                        = "nsgsr-${var.application_name}-agw-pe-${var.environment_name}-${var.location_short}-${var.resource_version}"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" 
  destination_port_range      = "*"
  source_address_prefix       = "10.0.2.0/24"
  destination_address_prefix  = "10.0.4.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  depends_on = [azurerm_network_security_group.main]
}