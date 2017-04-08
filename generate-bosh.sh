#!/bin/bash

set -ex

erb bosh-template.yml > bosh.yml
gcloud compute copy-files bosh.yml bosh-bastion:~/
gcloud compute copy-files ~/.ssh/google_compute_engine bosh-bastion:~/bosh_private_key
gcloud compute ssh bosh-bastion --command 'bosh-init deploy bosh.yml'

# gcloud config set compute/zone us-east1-d
# gcloud config set compute/region ${region}
