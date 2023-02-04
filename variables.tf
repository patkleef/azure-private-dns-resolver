variable "deploy_private_dns_resolver" {
    type = bool
    default = true
}

variable "deploy_vpn_gateway" {
    type = bool
    default = true
}

variable "enable_private_endpoint_storageaccount" {
    type = bool
    default = true
}

variable "deploy_custom_dns" {
    type = bool
    default = true
}