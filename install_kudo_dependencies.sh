function gcloudCommand() {
    gcloud compute ssh bosh-bastion --command "$1"
}

gcloudCommand 'sudo curl https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.1-linux-amd64 -o /usr/bin/bosh-cli'
gcloudCommand 'sudo chmod a+x /usr/bin/bosh-cli'
gcloudCommand 'curl -L https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/0.4.0/credhub-linux-0.4.0.tgz | tar zxv'
gcloudCommand 'chmod a+x credhub'
gcloudCommand 'sudo mv credhub /usr/bin'
gcloudCommand 'sudo curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/bin/kubectl'
gcloudCommand 'sudo chmod a+x /usr/bin/kubectl'
gcloudCommand 'git clone https://github.com/pivotal-cf-experimental/kubo-deployment.git'
