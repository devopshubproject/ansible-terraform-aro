### General ###

environment = "dev"

### Vnet ###

vnet_address_space = ["10.0.0.0/22", "10.224.52.0/23"]

### Subnet ###

subnet_address_spaces = {
  "dev-controlplane-snet" = {
    "name"                                           = "dev-northeurope-sas-data-snet",
    "cidr"                                           = ["10.0.0.0/23"]
    "enforce_private_link_service_network_policies"  = false
    "enforce_private_link_endpoint_network_policies" = false
  },

  "dev-bastion-snet" = {
    "name"                                           = "AzureBastionSubnet",
    "cidr"                                           = ["10.0.1.0/23"]
    "enforce_private_link_service_network_policies"  = false
    "enforce_private_link_endpoint_network_policies" = false
  },

  "dev-worker-snet" = {
    "name"                                           = "dev-northeurope-sas-databricksprivate-snet",
    "cidr"                                           = ["10.0.2.0/23"]
    "enforce_private_link_service_network_policies"  = false
    "enforce_private_link_endpoint_network_policies" = false
 }
}