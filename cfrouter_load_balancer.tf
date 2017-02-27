resource "aws_elb" "cfrouter" {
  name = "cfrouter"
  subnets = ["${aws_subnet.PcfVpcPublicSubnet_az1.id}","${aws_subnet.PcfVpcPublicSubnet_az2.id}"]
  security_groups = ["${aws_security_group.opsman.id}"]

  listener {
    instance_port = 8080
    instance_protocol = "HTTP"
    lb_port = 443
    lb_protocol = "HTTPS"
    ssl_certificate_id = "${var.aws_cert_arn}"
  }
  health_check {
    target = "TCP:80"
    timeout = 5
    interval = 30
    unhealthy_threshold = 2
    healthy_threshold = 10
  }
  tags {
    Name = "${var.environment}-cfrouter-Elb"
  }
}
