##################################################
# Providers
##################################################

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

##################################################
# locals for tagging
##################################################

locals {
  common_tags = {
    Owner       = "${var.owner}"
    Environment = "${var.environment}"
    CostCenter  = "${var.costcenter}"
    Application = "${var.app_name}"
    Department  = "${var.department}"
  }
}


###################################################
# Azure Resource Group
###################################################

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.location}-${var.app_name}-nw-rg"
  location = "${var.location}"
  tags     = "${local.common_tags}"
}


###################################################
# Azure Vnet
###################################################

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  name                = "${var.environment}-${var.location}-vnet"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = "${var.vnet_address_space}"
  tags                = "${local.common_tags}"
}


###################################################
# Azure Subnet
###################################################

resource "azurerm_subnet" "subnet" {
  resource_group_name                            = "${azurerm_resource_group.rg.name}"
  name                                           = "${each.value.name}"
  for_each                                       = "${var.subnet_address_spaces}"
  address_prefixes                               = "${each.value.cidr}"
  virtual_network_name                           = "${azurerm_virtual_network.vnet.name}"
  enforce_private_link_service_network_policies  = "${each.value.enforce_private_link_service_network_policies}"
  enforce_private_link_endpoint_network_policies = "${each.value.enforce_private_link_endpoint_network_policies}"
  depends_on                                     = [azurerm_resource_group.rg]
}

###################################################
# Azure Bastion
###################################################

resource "azurerm_public_ip" "bstnpip" {
  name                = "${var.environment}-${var.location}-bast-pip"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_subnet.subnet]

}

resource "azurerm_bastion_host" "bastion" {
  name                = "${var.environment}-${var.location}-bast"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  ip_configuration {
    name      = "configuration"
    subnet_id = "${azurerm_subnet.subnet["${var.environment}-bastion-snet"].id}"
    public_ip_address_id = "${azurerm_public_ip.bstnpip.id}"
  }
}