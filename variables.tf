variable "project_id" {
  default     = "tf-ref-project"
  description = "Terraform reference project using remote state managed in separate project"
}

variable "enabled_api" {
  description = "The list of enabled APIs for this project"
  type        = list(string)
  default = [
    "cloudbuild.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "storagetransfer.googleapis.com"
  ]
}