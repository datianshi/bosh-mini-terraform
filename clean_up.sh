bosh -n delete deployment aws-cf-diego
bosh -n delete deployment aws-cf
bosh-init delete bosh.yml
source env.sh
terraform destroy -force
