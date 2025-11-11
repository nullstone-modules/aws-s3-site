data "aws_region" "this" {}
locals {
  region = data.aws_region.this.region
}
