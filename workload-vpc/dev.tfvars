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
  rules = [
    { name        = "rule-1",
      action      = "allow",
      destination = "192.168.0.0/27",
      direction   = "inbound",
      source      = "192.168.0.0/26",
      tcp = {
        port_min        = 80,
        port_max        = 8080,
        source_port_min = 1024,
        source_port_max = 65535
      }
    },
    {
      name        = "rule-2",
      action      = "allow",
      destination = "192.168.0.0/27",
      direction   = "outbound",
      source      = "192.168.0.0/26",
      tcp = {
        port_min        = 80,
        port_max        = 8080,
        source_port_min = 1024,
        source_port_max = 65535
      }
    }
  ]
  },
  {
    name                         = "ipc-test-nonprod-orbo-acl",
    add_ibm_cloud_internal_rules = true,
    add_vpc_connectivity_rules   = false,
    prepend_ibm_rules            = true,
    rules = [
      {
        name        = "rule-2",
        action      = "allow",
        destination = "192.168.0.0/27",
        direction   = "inbound", source = "192.168.0.0/26",
        tcp = {
          port_min        = 58083,
          port_max        = 58083,
          source_port_min = 1024,
          source_port_max = 65535
        }
      }
    ]
  }
]

subnets = {
  zone-1 = [
    {
      "acl_name" : "ipc-test-nonprod-roks-acl",
      "cidr" : "192.168.0.0/26",
      "name" : "roks-dal01-subnet",
      "public_gateway" : false
    },
    { "acl_name" : "ipc-test-nonprod-orbo-acl",
      "cidr" : "192.168.0.64/27",
      "name" : "orbo-dal01-subnet",
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
