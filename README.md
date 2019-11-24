# Terraform Reference Project

This project `tf-ref-project` demonstrates provisioning of Google Cloud Platform resources through Terraform with backend state managed remotely through a cloud storage bucket in a separate project `tf-backend`

## Setup

1. Create a separate project `tf-backend` with a storage bucket to be used for storing the Terraform state
  - Add the name of the storage bucket to `backend.tf`
  - The prefix can be used to have multiple projects with separate directories in this bucket 
2. Create this project using `gcloud projects create tf-ref-project`
  - Retrieve the project ID using `gcloud projects list` and add it to `variables.tf`
3. Create a service account and grant it project editor access in `tf-ref-project`
  - Generate a key `key.json` for this service account and save to a subdirectory `/service-acct`
  - Grant the service account cloud storage editor access in `tf-backend`
4. Run `terraform init`
5. Run `terraform apply`

## Notes

- Running `terraform init` with reference to a GCS backend requires authentication
  - Use `gcloud config configurations activate [CONFIG NAME]`
  - Potentially also need to use `gcloud auth application-default login` to authenticate application default credentials
- Projects cannot be created without the `resourcemanager.projects.create` permission

## Cloud Build
- create a directory `.ssh` to hold keys (ensure this is in gitignore)
- create a new ssh key using `ssh-keygen -t rsa -b 4096 -C "[replace with email adderess]" -f .ssh/gcp_id_rsa -q -N ""`
- ensure the correct gcloud config is activated
- create a KMS keyring using `gcloud kms keyrings create gcp_github --location=global`
- create a key using `gcloud kms keys create github-key --location=global --keyring=gcp_github --purpose=encryption`
- encrypt ssh key with KMS key using `gcloud kms encrypt --plaintext-file=.ssh/gcp_id_rsa --ciphertext-file=gcp_id_rsa.enc --location=global --keyring=gcp_github --key=github-key`
- add decrypter IAM role to cloudbuild service account `gcloud kms keys add-iam-policy-binding github-key --location=global --keyring=gcp_github --member=serviceAccount:[replace with service account] --role=roles/cloudkms.cryptoKeyDecrypter`
- add key to known hosts `ssh-keyscan -t rsa github.com > known_hosts`
- in github repo, add public key `gcp_id_rsa.pub` to the deploy keys with read only access
- test the build pipeline using `gcloud builds submit --config=cloudbuild/cloudbuild.yaml .`

## Cloud Build with Terraform
- ensure that the cloud build service account has storage read and write access to the backend storage bucket
- the cloud build service account needs project editor access in order to list project services and create/edit them

## Setting up a Cloud Build Trigger
- From Cloud Build, go to `Triggers` and click `Connect Repository`
- Expand the options and select `GitHub (mirrored)` (need to authenticate into GitHub)
- Select the repo to be connected
- Add a trigger for pushes to master branch
- Select `Cloud Build configuration file (yaml or json)` and ensure that correct path location of the file is provided
- Any pushes to the master branch will trigger the `cloudbuild.yaml` build job to run


## To do
- enable cloud build API through terraform
