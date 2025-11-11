locals {
  cdn_ids  = [for cdn in local.capabilities.cdns : cdn.id]
  cdn_arns = [for cdn in local.capabilities.cdns : cdn.arn]
}
