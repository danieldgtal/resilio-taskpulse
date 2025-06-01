########################################
# backend.tf
########################################
terraform {
  backend "gcs" {
    bucket  = "gcp-learn-102-terraform-state"
    prefix  = "taskpulse/terraform/state"
  }
}
