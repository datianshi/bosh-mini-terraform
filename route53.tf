resource "aws_route53_record" "cfrouter" {
  zone_id = "${var.route53_zone_id}"
  name = "*.cf.shaozhenpcf.com"
  type = "CNAME"
  ttl = "900"
  records = ["${aws_elb.cfrouter.dns_name}"]
}
