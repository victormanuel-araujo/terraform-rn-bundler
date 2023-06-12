resource "azurerm_virtual_network" "vnet-zerocoder-appbundler" {
  name                = "vnet-zerocoder-appbundler"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-zerocoder-appbundler.name

  tags = {
    project = "ReactNativeBundler"
  }
}


resource "azurerm_subnet" "sub-zerocoder-appbundler" {
  name                 = "sub-zerocoder-appbundler"
  resource_group_name  = azurerm_resource_group.rg-zerocoder-appbundler.name
  virtual_network_name = azurerm_virtual_network.vnet-zerocoder-appbundler.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip-zerocoder-appbundler" {
  name                = "pip-zerocoder-appbundler"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-zerocoder-appbundler.name
  allocation_method   = "Static"

  tags = {
    project = "ReactNativeBundler"
  }
}

resource "azurerm_network_security_group" "nsg-zerocoder-appbundler" {
  name                = "nsg-zerocoder-appbundler"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-zerocoder-appbundler.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Bundle"
    priority                   = 800
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Web"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    project = "ReactNativeBundler"
  }
}

resource "azurerm_network_interface" "nic-zerocoder-appbundler" {
  name                = "nic-zerocoder-appbundler"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-zerocoder-appbundler.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.sub-zerocoder-appbundler.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-zerocoder-appbundler.id
  }

  tags = {
    project = "ReactNativeBundler"
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-zerocoder-appbundler" {
  network_interface_id      = azurerm_network_interface.nic-zerocoder-appbundler.id
  network_security_group_id = azurerm_network_security_group.nsg-zerocoder-appbundler.id
}
