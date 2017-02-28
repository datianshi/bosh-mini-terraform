
set -e
private_subnet_id=$(terraform state show aws_subnet.PcfVpcPrivateSubnet_az1|head -n 1|awk '{print $3}')
private_subnet_id2=$(terraform state show aws_subnet.PcfVpcPrivateSubnet_az2|head -n 1|awk '{print $3}')

cp cf-custom.yml cf-template.yml

# bosh upload release https://bosh.io/d/github.com/cloudfoundry/cf-release?v=252
# bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/garden-runc-release?v=1.0.0
# bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/diego-release?v=0.1476.0
# bosh upload release https://bosh.io/d/github.com/cloudfoundry/cflinuxfs2-rootfs-release
# bosh upload stemcell https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent?v=3363.9


uuid=$(bosh status --uuid)
perl -pi -e "s|{{uuid}}|${uuid}|g" cf-template.yml

perl -pi -e "s/{{AWS_KEY}}/${TF_VAR_aws_access_key}/g" cf-template.yml
perl -pi -e "s/{{AWS_SECRET}}/${TF_VAR_aws_secret_key}/g" cf-template.yml
perl -pi -e "s/{{zone1}}/${TF_VAR_az1}/g" cf-template.yml
perl -pi -e "s/{{zone2}}/${TF_VAR_az2}/g" cf-template.yml
perl -pi -e "s|{{subnet_az1}}|${private_subnet_id}|g" cf-template.yml
perl -pi -e "s|{{subnet_az2}}|${private_subnet_id2}|g" cf-template.yml
perl -pi -e "s|{{system_domain}}|${system_domain}|g" cf-template.yml

./cf-release/scripts/generate_deployment_manifest aws cf-template.yml > cf.yml

diego_template=$(dirname $0)/../diego-template

cp diego-template/iaas-settings-template.yml diego-template/iaas-settings.yml
perl -pi -e "s|{{subnet_az1}}|${private_subnet_id}|g" diego-template/iaas-settings.yml
perl -pi -e "s|{{subnet_az2}}|${private_subnet_id2}|g" diego-template/iaas-settings.yml
perl -pi -e "s/{{zone1}}/${TF_VAR_az1}/g" diego-template/iaas-settings.yml
perl -pi -e "s/{{zone2}}/${TF_VAR_az2}/g" diego-template/iaas-settings.yml

pushd diego-release
./scripts/generate-deployment-manifest \
    -c ../cf.yml \
    -i ${diego_template}/iaas-settings.yml \
    -p ${diego_template}/property-overrides.yml \
    -n ${diego_template}/instance-count-overrides.yml \
    -x \
    -s ${diego_template}/postgres.yml \
    > ../diego.yml
popd
