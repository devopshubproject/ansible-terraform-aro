###### General ######

variable "environment" {
  description = "The environment name"
}

variable "location" {
  description = "The Location for Infra centre"
  default     = "northeurope"
}


##### Global Variable #####

### Tags
variable "owner" {
  type        = string
  description = "The name of the infra provisioner or owner"
  default     = "Prem"
}

variable "costcenter" {
  type        = string
  description = "The cost_center name for this project"
  default     = "laya"
}

variable "app_name" {
  type        = string
  description = "Application name of this project"
  default     = "aro"
}

variable "department" {
  type        = string
  description = "The department name for this project"
  default     = "devopshub"
}

###### Network ######

### Vnet

variable "vnet_address_space" {
  description = "The environment address space CIDR range"
}

## Subnet

variable "subnet_address_spaces" {
  description = "The environment subnet address spaces CIDR range"
}
