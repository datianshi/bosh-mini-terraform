resource "aws_route53_record" "concourse" {
  zone_id = "${var.route53_zone_id}"
  name = "concourse"
  type = "CNAME"
  ttl = "900"
  records = ["${aws_elb.ConcourseElb.dns_name}"]
}
