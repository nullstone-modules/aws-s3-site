data "terraform_remote_state" "subdomain" {
  backend = "pg"

  workspace = "${var.stack_name}-${var.env}-${var.parent_blocks.subdomain}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}

locals {
  subdomain     = data.terraform_remote_state.subdomain.outputs.subdomain_name
  alt_subdomain = var.enable_www ? "www.${local.subdomain}" : ""
}
