locals {
  oai_iam_arns = [for oai in local.capabilities.origin_access_identities : oai.iam_arn]
}
