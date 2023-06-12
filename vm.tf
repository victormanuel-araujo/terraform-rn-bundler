resource "azurerm_linux_virtual_machine" "vm-zerocoder-appbundler" {
  name                  = "vm-zerocoder-appbundler"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg-zerocoder-appbundler.name
  network_interface_ids = [azurerm_network_interface.nic-zerocoder-appbundler.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "vm-zerocoder-appbundler"
  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  tags = {
    project = "ReactNativeBundler"
  }
}

output "public_ip" {
  value = azurerm_public_ip.pip-zerocoder-appbundler.ip_address
}
