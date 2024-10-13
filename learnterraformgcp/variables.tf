variable  "project_id" {
  type        = string
  description = "project id"
}

variable "credentials_file" {
  type        = string
  description = "credential file"
}

variable "gcp_region" {
  type        = string
  description = "gcp region"
}

variable "gcp_zone" {
  type        = string
  default = "us-west1-a"
  description = "gcp zone"
}