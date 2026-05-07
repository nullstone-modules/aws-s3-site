module "scaffold" {
  source = "registry.terraform.io/nullstone-modules/s3site-appscaffold/aws"

  block_ref       = data.ns_workspace.this.block_ref
  resource_suffix = random_string.resource_suffix.result
  tags            = local.tags
  bucket_arn      = aws_s3_bucket.this.arn
  cdn_arns        = local.cdn_arns
  op_assumer_arns = [local.ns_agent_user_arn]
}

// State migration for the CloudWatch log group extracted into the scaffold
// module. The deployer (previously an IAM user, now a role inside the scaffold)
// is intentionally not migrated — the contract change forces a destroy/create,
// see CHANGELOG.

moved {
  from = module.logs
  to   = module.scaffold.module.logs
}
