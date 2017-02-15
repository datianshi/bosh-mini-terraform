#!/bin/bash

cp bosh-template.yml bosh.yml
sec_id=$(terraform state show aws_security_group.directorSG|head -n 1|awk '{print $3}')
subnet_id=$(terraform state show aws_subnet.PcfVpcPublicSubnet_az1|head -n 1|awk '{print $3}')
uuid=$(bosh status --uuid)
elb_dns=$(terraform state show aws_elb.ConcourseElb | head -n 8 | tail -1|awk '{print $3}')
perl -pi -e "s/{{sgp}}/${sec_id}/g" bosh.yml
perl -pi -e "s/{{subnet}}/${subnet_id}/g" bosh.yml
perl -pi -e "s/{{AWS_KEY}}/${TF_VAR_aws_access_key}/g" bosh.yml
perl -pi -e "s/{{AWS_SECRET}}/${TF_VAR_aws_secret_key}/g" bosh.yml
perl -pi -e "s/{{KEY_NAME}}/${TF_VAR_aws_key_name}/g" bosh.yml
perl -pi -e "s|{{KEY_LOCAL_PATH}}|${KEY_LOCAL_PATH}|g" bosh.yml
perl -pi -e "s|{{ELASTIC_IP}}|${ELASTIC_IP}|g" bosh.yml

cp cloud-config-template.yml cloud-config.yml

perl -pi -e "s|{{my_subnet}}|${subnet_id}|g" cloud-config.yml

cp concourse-template.yml concourse.yml

perl -pi -e "s|{{uuid}}|${uuid}|g" concourse.yml
perl -pi -e "s|{{ELB_DNS}}|${elb_dns}|g" concourse.yml
