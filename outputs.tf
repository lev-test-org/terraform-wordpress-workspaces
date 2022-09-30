output "wordpress-vpc" {
 value = tfe_workspace.wordpress-vpc
}
output "wordpress-rds" {
 value = tfe_workspace.wordpress-rds
}
output "compute_groups" {
  value = var.compute_groups
}

output "wordpress-compute" {
 value = tfe_workspace.wordpress-compute
}
