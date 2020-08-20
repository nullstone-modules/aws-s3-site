resource "aws_acm_certificate" "this" {
  domain_name               = local.subdomain
  validation_method         = "DNS"
  subject_alternative_names = compact([local.alt_subdomain])

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

resource "aws_route53_record" "cert_validation" {
  count = var.enable_www ? 2 : 1

  name            = aws_acm_certificate.this.domain_validation_options[count.index]["resource_record_name"]
  type            = "CNAME"
  allow_overwrite = true
  zone_id         = data.terraform_remote_state.subdomain[count.index].outputs.subdomain_zone_id
  records         = [aws_acm_certificate.this.domain_validation_options[count.index]["resource_record_value"]]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
