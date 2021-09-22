locals {
  origin_access_identities = lookup(local.capabilities, "origin_access_identities", [])

  oai_iam_arns = [for oai in local.origin_access_identities : oai.iam_arn]
}
