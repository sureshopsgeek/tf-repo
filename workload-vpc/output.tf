# ##############################################################################
# # Outputs
# ##############################################################################
output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_id" {
  value = module.resource_group.id
}
# output "vpc_name" {
#   description = "VPC name"
#   value       = module.workload_vpc.vpc_name
# }
# output "vpc_name" {
#   value = {
#     for key, value in module.workload_vpc : key => value.name
#   }
# }
# output "vpc_name" {
#   value = module.workload_vpc.vpc_name
# }
# output "vpc_id" {
#   description = "ID of VPC created"
#   value       = module.workload_vpc.vpc_id
# }

# output "vpc_crn" {
#   description = "CRN of VPC created"
#   value       = module.workload_vpc.vpc_crn
# }


