data "aws_route53_zone" "selected" {
  name         = "sg-faas-plurall.com"
  private_zone = false 
}

resource "aws_route53_record" "ed_bucket" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "ed-test.sg-faas-plurall.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
