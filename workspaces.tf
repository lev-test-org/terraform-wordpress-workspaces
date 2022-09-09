resource "tfe_workspace" "wordpress-vpc" {
  name         = "${var.env}-wordpress-vpc"
  organization = var.organization
  tag_names    = concat(var.tfe_tags,["${var.env}"])
  auto_apply = true
  trigger_prefixes = ["vpc"]
  working_directory = "vpc"
  vcs_repo  {
    identifier = "lev-test-org/wordpress-aws"
    branch = var.branch
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
  remote_state_consumer_ids = [tfe_workspace.wordpress-rds.id,tfe_workspace.wordpress-compute.id]
  depends_on = [tfe_variable_set.common_vars,data.tfe_variable_set.cred_var_set]
}

resource "tfe_workspace" "wordpress-rds" {
  name         = "${var.env}-wordpress-rds"
  organization = var.organization
  tag_names    = concat(var.tfe_tags,["${var.env}"])
  auto_apply = true
  trigger_prefixes = ["rds"]
  working_directory = "rds"
  vcs_repo  {
    identifier = "lev-test-org/wordpress-aws"
    branch = var.branch
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
  remote_state_consumer_ids = [tfe_workspace.wordpress-compute.id]
  depends_on = [tfe_workspace.wordpress-vpc]
}

resource "tfe_run_trigger" "wordpress-rds-trigger" {
  workspace_id  = tfe_workspace.wordpress-rds.id
  sourceable_id = tfe_workspace.wordpress-vpc.id
}

resource "tfe_workspace" "wordpress-compute" {
  name         = "${var.env}-wordpress-compute"
  organization = var.organization
  tag_names    = concat(var.tfe_tags,["${var.env}"])
  auto_apply = true
  trigger_prefixes = ["wordpress-compute"]
  working_directory = "wordpress-compute"
  vcs_repo  {
    identifier = "lev-test-org/wordpress-aws"
    branch = var.branch
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
  depends_on = [tfe_workspace.wordpress-compute]
}

resource "tfe_run_trigger" "wordpress-compute-trigger" {
  workspace_id  = tfe_workspace.wordpress-compute.id
  sourceable_id = tfe_workspace.wordpress-rds.id
}
