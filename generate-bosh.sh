#!/bin/bash

set -ex

cp bosh-template.yml bosh.yml
sec_id=$(terraform state show aws_security_group.directorSG|head -n 1|awk '{print $3}')
subnet_id=$(terraform state show aws_subnet.PcfVpcPublicSubnet_az1|head -n 1|awk '{print $3}')
private_subnet_id=$(terraform state show aws_subnet.PcfVpcPrivateSubnet_az1|head -n 1|awk '{print $3}')

elb_dns="https://concourse.shaozhenpcf.com"
perl -pi -e "s/{{sgp}}/${sec_id}/g" bosh.yml
perl -pi -e "s/{{subnet}}/${subnet_id}/g" bosh.yml
perl -pi -e "s/{{AWS_KEY}}/${TF_VAR_aws_access_key}/g" bosh.yml
perl -pi -e "s/{{AWS_SECRET}}/${TF_VAR_aws_secret_key}/g" bosh.yml
perl -pi -e "s/{{KEY_NAME}}/${TF_VAR_aws_key_name}/g" bosh.yml
perl -pi -e "s|{{KEY_LOCAL_PATH}}|${KEY_LOCAL_PATH}|g" bosh.yml
perl -pi -e "s|{{ELASTIC_IP}}|${ELASTIC_IP}|g" bosh.yml

# bosh-init deploy bosh.yml
# bosh target ${ELASTIC_IP}
# bosh login admin admin

uuid=$(bosh status --uuid)

cp cloud-config-template.yml cloud-config.yml

perl -pi -e "s|{{my_subnet}}|${private_subnet_id}|g" cloud-config.yml

bosh update cloud-config cloud-config.yml

bosh upload stemcell https://bosh.io/d/stemcells/bosh-aws-xen-ubuntu-trusty-go_agent?v=3312.18

cp concourse-template.yml concourse.yml

perl -pi -e "s|{{uuid}}|${uuid}|g" concourse.yml
perl -pi -e "s|{{ELB_DNS}}|${elb_dns}|g" concourse.yml

bosh deployment concourse.yml
bosh -n deploy
