function gcloudCommand() {
    gcloud compute ssh bosh-bastion --command "$1"
}

function exportRelease() {
  gcloudCommand "bosh upload stemcell $1 --skip-if-exists"
}
