module "resource_group" {
  source   = "../modules/azurerm_rg"
  rg_name  = "rg_jio"
  location = "westus"
}

module "vnet" {
    depends_on = [module.resource_group]
    source = "../modules/azurerm_vnet"
    vnet_name = "vnet_jio"
    location = "westus"
    rg_name = "rg_jio"
    address_space = ["10.0.0.0/16"]
}

module "subnet_frount" {
    depends_on = [module.vnet]
    source = "../modules/azurerm_subnet"
    subnet_name = "subnet_frountjio"
    vnet_name = "vnet_jio"
    rg_name = "rg_jio"
    address_prefixes = ["10.0.1.0/24"]
}

module "subnet_back" {
    depends_on = [module.vnet]
    source = "../modules/azurerm_subnet"
    subnet_name = "subnet_backjio"
    vnet_name = "vnet_jio"
    rg_name = "rg_jio"
    address_prefixes = ["10.0.2.0/24"]

}

module "pip_frount" {
    depends_on = [module.subnet_frount]
    source = "../modules/azurerm_pip"
    pip_name = "pip_frountjio"
    location = "westus"
    rg_name = "rg_jio"
    allocation_method = "Dynamic"
    sku = "Basic"
}
module "pip_back" {
    depends_on = [module.subnet_back]
    source = "../modules/azurerm_pip"
    pip_name = "pip_backjio"
    location = "westus"
    rg_name = "rg_jio"
    allocation_method = "Dynamic"
    sku = "Basic"
}

module "nic_frount" {
    depends_on = [module.subnet_frount]
    source = "../Modules/azurerm_nic"
    nic_name = "nic_fjio"
    location = "westus"
    vnet_name = "vnet_jio"
    pip_name = "pip_frountjio"
    rg_name = "rg_jio"
    subnet_name = "subnet_frountjio"
    ip_name = "ip_frountjio"
    private_ip_allocation = "Dynamic"

}

module "nic_back" {
    depends_on = [module.subnet_back]
    source = "../modules/azurerm_nic"
    nic_name = "nic_bjio"
    location = "westus"
    vnet_name = "vnet_jio"
    pip_name = "pip_backjio"
rg_name = "rg_jio"
ip_name = "ip_backjio"
subnet_name = "subnet_backjio"
private_ip_allocation = "Dynamic"
}

module "vm_frount" {
    depends_on = [module.nic_frount]
    source = "../modules/azurerm_vm"
    vm_name = "vmfjio"
    location = "westus"
    rg_name = "rg_jio"
    nic_name = "nic_fjio"
    size = "Standard_B1s"
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
}

module "vm_back" {
    depends_on = [module.nic_back]
    source = "../modules/azurerm_vm"
    vm_name = "vmbjio"
    location = "westus"
    rg_name = "rg_jio"
    nic_name = "nic_bjio"
    size = "Standard_B1s"
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-focal"
    sku = "20_04-lts"
}