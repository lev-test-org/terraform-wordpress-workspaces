resource "tfe_variable_set" "common_vars" {
  name          = "Wordpress vars ${var.env}"
  description   = "Variables shared for multiple workspaces of wordpress project"
  organization  = var.organization
}
data "tfe_variable_set" "cred_var_set" {
  name         = "${var.cred_var_set}"
  organization = "${var.organization}"
}

resource "tfe_workspace_variable_set" "cred_var_set" {
  for_each = toset(concat([tfe_workspace.wordpress-vpc.id,tfe_workspace.wordpress-rds.id],[ for cp in var.compute_groups : tfe_workspace.wordpress-compute[cp].id]))
  variable_set_id = data.tfe_variable_set.cred_var_set.id
  workspace_id    = each.value
}

resource "tfe_workspace_variable_set" "common_vars" {
  for_each = toset(concat([tfe_workspace.wordpress-vpc.id,tfe_workspace.wordpress-rds.id],[ for cp in var.compute_groups : tfe_workspace.wordpress-compute[cp].id]))
  variable_set_id = tfe_variable_set.common_vars.id
  workspace_id    = each.value
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
