data "aws_route53_zone" "apkas" {
  name = "apkas.net."
}

resource "aws_route53_record" "diary" {
  zone_id = data.aws_route53_zone.apkas.zone_id
  name = "diary.apkas.net"
  type = "CNAME"
  ttl = 300
  records = ["ceshmina.github.io"]
}

resource "aws_route53_record" "photos" {
  zone_id = data.aws_route53_zone.apkas.zone_id
  name = "photos.apkas.net"
  type = "CNAME"
  ttl = 300
  records = [aws_cloudfront_distribution.photos.domain_name]
}

resource "aws_acm_certificate" "photos" {
  domain_name = "photos.apkas.net"
  validation_method = "DNS"
  provider = aws.virginia
}

resource "aws_route53_record" "photos_cert" {
  zone_id = data.aws_route53_zone.apkas.zone_id
  name = tolist(aws_acm_certificate.photos.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.photos.domain_validation_options)[0].resource_record_type
  ttl = 60
  records = [tolist(aws_acm_certificate.photos.domain_validation_options)[0].resource_record_value]
}

resource "aws_acm_certificate_validation" "photos" {
  certificate_arn = aws_acm_certificate.photos.arn
  validation_record_fqdns = [aws_route53_record.photos_cert.fqdn]
  provider = aws.virginia
}
