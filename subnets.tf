/*
  For First availability zone
*/

# 1. Create Public Subnet
resource "aws_subnet" "PcfVpcPublicSubnet_az1" {
    vpc_id = "${aws_vpc.PcfVpc.id}"

    cidr_block = "${var.public_subnet_cidr_az1}"
    availability_zone = "${var.az1}"

    tags {
        Name = "${var.environment}-PcfVpc Public Subnet AZ1"
    }
}

resource "aws_subnet" "PcfVpcPublicSubnet_az2" {
    vpc_id = "${aws_vpc.PcfVpc.id}"

    cidr_block = "${var.public_subnet_cidr_az2}"
    availability_zone = "${var.az2}"

    tags {
        Name = "${var.environment}-PcfVpc Public Subnet AZ2"
    }
}


# 2. Create Private Subnets
# 2.1 ERT
resource "aws_subnet" "PcfVpcPrivateSubnet_az1" {
    vpc_id = "${aws_vpc.PcfVpc.id}"

    cidr_block = "${var.private_subnet_cidr_az1}"
    availability_zone = "${var.az1}"

    tags {
        Name = "${var.environment}-PcfVpc Ert Subnet AZ1"
    }
}

resource "aws_subnet" "PcfVpcPrivateSubnet_az2" {
    vpc_id = "${aws_vpc.PcfVpc.id}"

    cidr_block = "${var.private_subnet_cidr_az2}"
    availability_zone = "${var.az2}"

    tags {
        Name = "${var.environment}-PcfVpc Ert Subnet AZ2"
    }
}


# Infrastructure network  - For bosh director
resource "aws_subnet" "PcfVpcInfraSubnet_az1" {
    vpc_id = "${aws_vpc.PcfVpc.id}"

    cidr_block = "${var.infra_subnet_cidr_az1}"
    availability_zone = "${var.az1}"

    tags {
        Name = "${var.environment}-PcfVpc Infrastructure Subnet"
    }
}
