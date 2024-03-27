region = "us-south"
prefix = "ipc-test-nonprod"
vpc = {
  config = {
    workload_vpc = {
      create_vpc      = true,
      vpc_tags        = ["env:nonprod", "customer:bns", "service:security"],
      vpc_access_tags = [],
      region          = "us-south",
      classic_access  = false
    }
  }
}
address_prefixes = {
  zone-1 = ["192.168.0.0/24"],
  zone-2 = ["192.168.1.0/24"],
  zone-3 = ["192.168.2.0/24"]
}

network_acls = [{
  name                         = "ipc-test-nonprod-roks-acl",
  add_ibm_cloud_internal_rules = true,
  add_vpc_connectivity_rules   = false,
  prepend_ibm_rules            = true,
  rules = [ {name = "rule-1", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 80, port_max = 8080, source_port_min = 1024, source_port_max = 65535}},
            {name = "rule-2", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 8080, port_max = 80, source_port_min = 1024, source_port_max = 65535}},
            {name = "rule-3", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}},
            {name = "rule-4", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}}]
}]

subnets = {
  zone-1 = [
    {
      "acl_name" : "ipc-test-nonprod-roks-acl",
      "cidr" : "192.168.0.0/26",
      "name" : "roks-dal01-subnet",
      "public_gateway" : false
    },

  ]
  zone-2 = [
    { "acl_name" : "ipc-test-nonprod-roks-acl",
      "cidr" : "192.168.1.0/26",
      "name" : "roks-dal02-subnet",
      "public_gateway" : false
    },
  ]
  zone-3 = [
    { "acl_name" : "ipc-test-nonprod-roks-acl",
      "cidr" : "192.168.2.0/26",
      "name" : "roks-dal03-subnet",
      "public_gateway" : false
    },
  ]
}


variable "network_acls"  {
  default = [{
    name                         = "ipc-test-nonprod-roks-acl"
    add_ibm_cloud_internal_rules = true
    add_vpc_connectivity_rules   = false
    prepend_ibm_rules            = true
    rules = [ {name = "rule-1", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 80, port_max = 80, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-2", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 8080, port_max = 8080, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-3", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-4", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-5", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 443, port_max = 443, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-6", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 443, port_max = 443, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-7", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26"} ]
      }  
  ]
}


variable "network_acls"  {
  default = [{
    name                         = "ipc-test-nonprod-roks-acl"
    add_ibm_cloud_internal_rules = true
    add_vpc_connectivity_rules   = false
    prepend_ibm_rules            = true
    rules = [ {name = "rule-1", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 80, port_max = 80, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-2", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 8080, port_max = 8080, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-3", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-4", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 22, port_max = 22, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-5", action = "allow", destination = "192.168.0.0/27", direction = "inbound", source = "192.168.0.0/26", tcp = {port_min = 443, port_max = 443, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-6", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26", tcp = {port_min = 443, port_max = 443, source_port_min = 1024, source_port_max = 65535}},
              {name = "rule-7", action = "allow", destination = "192.168.0.0/27", direction = "outbound", source = "192.168.0.0/26"},]
      }  
  ]
}