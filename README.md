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