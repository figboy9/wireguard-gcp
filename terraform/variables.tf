variable "project_id" {
  description = "Project ID of GCP"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "us-west1-b"
}
