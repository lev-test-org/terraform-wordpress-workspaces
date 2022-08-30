data "tfe_workspace_ids" "all_wordpress" {
  names        = ["*"]
  tag_names = ["wordpress-aws"]
  organization = var.organization
}

resource "tfe_variable_set" "common_vars" {
  name          = "Wordpress vars"
  description   = "Variables shared for multiple workspaces of wordpress project"
  organization  = var.organization
  workspace_ids = length(data.tfe_workspace_ids.all_wordpress) == 0 ? [""] : values(data.tfe_workspace_ids.all_wordpress.ids)
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