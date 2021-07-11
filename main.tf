data "azurerm_client_config" "current" {
}

###################################################
# Azure Resource Group
###################################################

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.location}-${var.app_name}-aro-rg"
  location = "${var.location}"
  tags     = "${local.common_tags}"
}


##################################################
# Azure Private DNS Zone
##################################################

resource "azurerm_private_dns_zone" "pvtdns" {
  name                = "laya-aro.dev.com"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags       = "${local.common_tags}"
}



##################################################
# Deploy ARO using ARM template
##################################################

resource "azurerm_template_deployment" "aro" {
  name                = "${var.environment}-${var.location}-aro"
  resource_group_name = "${azurerm_resource_group.rd.name}"

  template_body = file("${path.module}/arm/aro-cluster.json")

  parameters = {
    "clientId"                 = var.clientId
    "clientSecret"             = var.clientSecret
    "clusterName"              = "openshift-cluster-${local.environment}"
    "clusterResourceGroupName" = azurerm_resource_group.openshift-cluster.name
    "domain"                   = local.domain_name
    "location"                 = var.location
    "masterSubnetId"           = azurerm_subnet.master-subnet.id
    "pullSecret"               = file("${path.module}/pull-secret.txt")
    "tags"                     = jsonencode(local.common_tags)
    "workerSubnetId"           = azurerm_subnet.worker-subnet.id
  }

  deployment_mode = "Incremental"

  depends_on = [
    azurerm_subnet.master-subnet,
    azurerm_subnet.worker-subnet
  ]
}