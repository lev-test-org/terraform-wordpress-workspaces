resource "tfe_variable_set" "common_vars" {
  name          = "Wordpress vars ${var.env}"
  description   = "Variables shared for multiple workspaces of wordpress project"
  organization  = var.organization
}
resource "tfe_workspace_variable_set" "test" {
  for_each = to_set([tfe_workspace.wordpress-vpc.id,tfe_workspace.wordpress-rds.id,tfe_workspace.wordpress-compute.id])
  variable_set_id = tfe_variable_set.common_vars.id
  workspace_id    = each.key
}
resource "tfe_variable" "vpc_cidr" {
  key             = "vpc_cidr"
  value           = var.vpc_cidr
  category        = "terraform"
  description     = "cidr of the vpc"
  variable_set_id = tfe_variable_set.common_vars.id
}

resource "tfe_variable" "tags" {
  hcl = true
  key             = "tags"
  value           = "{\n \"Terraform\" = \"true\" \n \"Environment\" = \"dev\" \n \"Owner\" = \"${var.owner}\"\n}"
  category        = "terraform"
  description     = "tags for aws resources"
  variable_set_id = tfe_variable_set.common_vars.id
}
resource "tfe_variable" "name" {
  key             = "name"
  value           = var.name
  category        = "terraform"
  description     = "tags for aws resources"
  variable_set_id = tfe_variable_set.common_vars.id
}

resource "tfe_variable" "env" {
  key             = "env"
  value           = var.env
  category        = "terraform"
  description     = "Environment name"
  variable_set_id = tfe_variable_set.common_vars.id
}
