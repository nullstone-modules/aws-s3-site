provider "aws" {
  default_tags {
    tags = local.tags
  }
}

data "aws_region" "this" {}
locals {
  region = data.aws_region.this.region
}
