#!/bin/bash

cp bosh-template.yml bosh.yml
sec_id=$(terraform state show aws_security_group.directorSG|head -n 1|awk '{print $3}')
subnet_id=$(terraform state show aws_subnet.PcfVpcInfraSubnet_az1|head -n 1|awk '{print $3}')
perl -pi -e "s/{{sgp}}/${sec_id}/g" bosh.yml
perl -pi -e "s/{{subnet}}/${subnet_id}/g" bosh.yml
