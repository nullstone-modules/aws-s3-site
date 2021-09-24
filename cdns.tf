locals {
  cdn_ids  = [for cdn in try(local.capabilities.cdns, []) : cdn["id"]]
  cdn_arns = [for cdn in try(local.capabilities.cdns, []) : cdn["arn"]]
}