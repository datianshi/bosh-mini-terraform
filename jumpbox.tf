# Create OpsMan instance
resource "aws_instance" "jumpbox" {
    ami = "${var.jumpbox_ami}"
    availability_zone = "${var.az1}"
    instance_type = "${var.jumpbox_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.jumpbox.id}"]
    subnet_id = "${aws_subnet.PcfVpcPublicSubnet_az1.id}"
    associate_public_ip_address = true
    root_block_device {
        volume_size = 100
    }
    tags {
        Name = "${var.environment}-Jumpbox"
    }
}
