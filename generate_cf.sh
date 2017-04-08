set -e

export vip=$(terraform output ip)
export tcp_vip=$(terraform output tcp_ip)
export zone=$(terraform output zone)
export zone_compilation=$(terraform output zone_compilation)
export region=$(terraform output region)
export region_compilation=$(terraform output region_compilation)
export private_subnet=$(terraform output private_subnet)
export compilation_subnet=$(terraform output compilation_subnet)
export network=$(terraform output network)

function gcloudCommand() {
    gcloud compute ssh bosh-bastion --command "$1"
}

function uploadStemcell() {
  gcloudCommand "bosh upload stemcell $1 --skip-if-exists"
}

function uploadRelease() {
  gcloudCommand "bosh upload release $1 --skip-if-exists"
}

gcloudCommand 'bosh -n target 10.0.0.6'
gcloudCommand 'bosh login admin admin'
export director=$(gcloudCommand 'bosh status --uuid')

# uploadStemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3312.15
# uploadRelease https://bosh.io/d/github.com/cloudfoundry/cf-mysql-release?v=23
# uploadRelease https://bosh.io/d/github.com/cloudfoundry-incubator/garden-linux-release?v=0.340.0
# uploadRelease https://bosh.io/d/github.com/cloudfoundry-incubator/etcd-release?v=43
# uploadRelease https://bosh.io/d/github.com/cloudfoundry-incubator/diego-release?v=0.1463.0
# uploadRelease https://bosh.io/d/github.com/cloudfoundry/cf-release?v=249
# uploadRelease https://bosh.io/d/github.com/cloudfoundry-incubator/cf-routing-release?v=0.142.0


erb cf-template.yml > cf.yml
gcloud compute copy-files cf.yml bosh-bastion:~/
gcloudCommand 'bosh deployment cf.yml'
gcloudCommand 'bosh -n deploy'
