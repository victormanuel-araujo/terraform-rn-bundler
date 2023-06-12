terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }

  required_version = "1.4.6"
}

resource "azurerm_resource_group" "rg-zerocoder-appbundler" {
  name     = "rg-zerocoder-appbundler"
  location = "East US"

  tags = {
    project = "ReactNativeBundler"
  }
}

resource "null_resource" "install-node" {
  triggers = {
    order = azurerm_linux_virtual_machine.vm-zerocoder-appbundler.id
  }

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.pip-zerocoder-appbundler.ip_address
    user     = var.admin_username
    password = var.admin_password
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - ",
      "sudo apt update",
      "sudo apt install -y nodejs",
      "sudo npm i -g yarn",
      "sudo apt install -y nginx",
    ]
  }

  depends_on = [azurerm_linux_virtual_machine.vm-zerocoder-appbundler]
}