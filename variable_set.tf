data "tfe_workspace_ids" "all_wordpress" {
  names        = ["*"]
  tag_names = [var.env]
  organization = var.organization
  depends_on = [tfe_workspace.wordpress-compute,tfe_workspace.wordpress-rds,tfe_workspace.wordpress-vpc]
}

resource "tfe_variable_set" "common_vars" {
  name          = "Wordpress vars ${var.env}"
  description   = "Variables shared for multiple workspaces of wordpress project"
  organization  = var.organization
  //workspace_ids = length(data.tfe_workspace_ids.all_wordpress) == 0 ? [""] : values(data.tfe_workspace_ids.all_wordpress.ids)
 // replacing datasource to specific before tryig to iterate
  workspace_ids = [tfe_workspace.wordpress-compute.id,tfe_workspace.wordpress-rds.id,tfe_workspace.wordpress-vpc.id ]
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
