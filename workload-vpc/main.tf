########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.4"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-rg" : null
  existing_resource_group_name = var.resource_group
}

#############################################################################
# Provision VPC
#############################################################################

module "workload_vpc" {
  source                                 = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc.git?ref=v7.17.1"
  for_each                               = var.vpc.config
  name                                   = "${var.prefix}-vpc"
  create_vpc                             = each.value.create_vpc
  tags                                   = each.value.vpc_tags
  access_tags                            = each.value.vpc_access_tags
  resource_group_id                      = module.resource_group.resource_group_id
  region                                 = each.value.region
  prefix                                 = null
  network_cidrs                          = []
  classic_access                         = each.value.classic_access
  default_network_acl_name               = "${var.prefix}-default-acl"
  default_security_group_name            = "${var.prefix}-default-sg"
  default_routing_table_name             = "${var.prefix}-default-rt"
  address_prefixes                       = var.address_prefixes
  network_acls                           = var.network_acls
  use_public_gateways                    = var.use_public_gateways
  subnets                                = var.subnets
  enable_vpc_flow_logs                   = var.enable_vpc_flow_logs
  create_authorization_policy_vpc_to_cos = var.create_authorization_policy_vpc_to_cos
  existing_cos_instance_guid             = var.existing_cos_instance_guid
  existing_storage_bucket_name           = var.existing_cos_bucket_name
  clean_default_sg_acl                   = var.clean_default_sg_acl
  security_group_rules                   = var.default_security_group_rules == null ? [] : var.default_security_group_rules
}


# module   "address_prefix" {

#   for_each = var.address_range.config
#   source   = "terraform-ibm-modules/vpc/ibm//modules/vpc-address-prefix"
#   version  = "1.1.1"
#   name     = join("-", [var.cust_id, each.value.suffix])
#   vpc_id   = local.vpc[each.value.vpc]
#   location = var.zone[each.value.az].alias
#   ip_range = each.value["cidr"]

# }