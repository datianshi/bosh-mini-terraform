#!/bin/bash

set -ex

erb bosh-template.yml > bosh.yml
gcloud compute copy-files bosh.yml bosh-bastion:~/
gcloud compute copy-files ~/.ssh/google_compute_engine bosh-bastion:~/bosh_private_key
gcloud compute ssh bosh-bastion --command 'bosh-init deploy bosh.yml'

# bosh-init deploy bosh.yml
# bosh target ${ELASTIC_IP}
# bosh login admin admin

# uuid=$(bosh status --uuid)

# cp cloud-config-template.yml cloud-config.yml
#
# perl -pi -e "s|{{my_subnet}}|${private_subnet_id}|g" cloud-config.yml
# perl -pi -e "s|{{subnet_az1}}|${private_subnet_id}|g" cloud-config.yml
# perl -pi -e "s|{{subnet_az2}}|${private_subnet_id2}|g" cloud-config.yml

# bosh update cloud-config cloud-config.yml
#
# bosh upload stemcell https://bosh.io/d/stemcells/bosh-aws-xen-ubuntu-trusty-go_agent?v=3312.18
#
# cp concourse-template.yml concourse.yml
#
# perl -pi -e "s|{{uuid}}|${uuid}|g" concourse.yml
# perl -pi -e "s|{{ELB_DNS}}|${elb_dns}|g" concourse.yml
#
# bosh deployment concourse.yml
# bosh -n deploy
