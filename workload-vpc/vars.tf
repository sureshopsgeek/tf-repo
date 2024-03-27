variable "region" {
  description = "The region to which to deploy the VPC"
  type        = string
  default     = "us-south"
}

variable "prefix" {
  description = "The prefix that you would like to append to your resources"
  type        = string
  default     = "ipc-test-nonprod"
}

variable "vpc" {
  default = {
    config = {
      workload_vpc = { create_vpc = true, vpc_tags = ["env:nonprod", "customer:bns", "service:security"], vpc_access_tags = [], region = "us-south", classic_access = false }
    }
  }
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}


#############################################################################
# VPC variables
#############################################################################

variable "default_security_group_rules" {
  description = "Override default security group rules"
  type = list(
    object({
      name      = string
      direction = string
      remote    = string
      tcp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      udp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      icmp = optional(
        object({
          type = optional(number)
          code = optional(number)
        })
      )
    })
  )

  default = []
}

variable "clean_default_sg_acl" {
  description = "Remove all rules from the default VPC security group and VPC ACL (less permissive)"
  type        = bool
  default     = false
}

variable "address_prefixes" {
  description = "Use `address_prefixes` only if `use_manual_address_prefixes` is true otherwise prefixes will not be created. Use only if you need to manage prefixes manually."
  type = object({
    zone-1 = optional(list(string))
    zone-2 = optional(list(string))
    zone-3 = optional(list(string))
  })

  default = { zone-1 = ["192.168.0.0/24"], zone-2 = ["192.168.1.0/24"], zone-3 = ["192.168.2.0/24"] }
}


# variable "address_range" {
#   default = {
#     config = {
#       zone-1     = { suffix = "test-1", cidr= "192.168.0.0/24", vpc = "workload_vpc", az = "zone-1" }
#       zone-2     = { suffix = "test-1", cidr= "192.168.1.0/24", vpc = "workload_vpc", az = "zone-2" }
#       zone-3     = { suffix = "test-1", cidr= "192.168.2.0/24", vpc = "workload_vpc", az = "zone-3" }


#     }
#   }
# }


# variable "network_acls" {
#   description = "List of network ACLs to create with VPC"
#   type = list(
#     object({
#       name                         = string
#       add_ibm_cloud_internal_rules = optional(bool)
#       add_vpc_connectivity_rules   = optional(bool)
#       prepend_ibm_rules            = optional(bool)
#       rules = list(
#         object({
#           name        = string
#           action      = string
#           destination = string
#           direction   = string
#           source      = string
#           tcp = optional(
#             object({
#               port_max        = optional(number)
#               port_min        = optional(number)
#               source_port_max = optional(number)
#               source_port_min = optional(number)
#             })
#           )
#           udp = optional(
#             object({
#               port_max        = optional(number)
#               port_min        = optional(number)
#               source_port_max = optional(number)
#               source_port_min = optional(number)
#             })
#           )
#           icmp = optional(
#             object({
#               type = optional(number)
#               code = optional(number)
#             })
#           )
#         })
#       )
#     })
#   )
# }

variable "network_acls"  {
  default = [{
    name                         = "ipc-test-nonprod-roks-acl"
    add_ibm_cloud_internal_rules = true
    add_vpc_connectivity_rules   = false
    prepend_ibm_rules            = true
    rules = [ {name = "rule-1", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 80, port_max = 8080, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-2", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 8080, port_max = 80, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-3", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-4", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}}]
    }  
  ]
}

variable "use_public_gateways" {
  description = "For each `zone` that is set to `true`, a public gateway will be created in that zone"
  type = object({
    zone-1 = optional(bool)
    zone-2 = optional(bool)
    zone-3 = optional(bool)
  })
  default = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}


variable "subnets" {
  description = "Object for subnets to be created in each zone, each zone can have any number of subnets"
  type = object({
    zone-1 = list(object({
      name           = string
      cidr           = string
      public_gateway = optional(bool)
      acl_name       = string
    }))
    zone-2 = list(object({
      name           = string
      cidr           = string
      public_gateway = optional(bool)
      acl_name       = string
    }))
    zone-3 = list(object({
      name           = string
      cidr           = string
      public_gateway = optional(bool)
      acl_name       = string
    }))
  })
}

# variable "zone" {
#   default = {
#       az1 = { alias = "us-south-1", dc = "dal01", region = "us-south" }
#       az2 = { alias = "us-south-2", dc = "dal02", region = "us-south" }
#       az3 = { alias = "us-south-3", dc = "dal03", region = "us-south" }
#   }
# }


#############################################################################
# Variables for COS and Flow Logs
#############################################################################

variable "enable_vpc_flow_logs" {
  type        = bool
  description = "Enable VPC Flow Logs, it will create Flow logs collector if set to true"
  default     = false
}

variable "create_authorization_policy_vpc_to_cos" {
  description = "Set it to true if authorization policy is required for VPC to access COS"
  type        = bool
  default     = false
}

variable "existing_cos_instance_guid" {
  description = "GUID of the COS instance to create Flow log collector"
  type        = string
  default     = null
}

variable "existing_cos_bucket_name" {
  description = "Name of the COS bucket to collect VPC flow logs"
  type        = string
  default     = null
}
