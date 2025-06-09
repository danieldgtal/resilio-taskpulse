########################################
# variables.tf
########################################
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default = "gcp-learn-102"
}

variable "zone" {
  description = "The zone for GCP resources"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "taskpulse-cluster"
}

variable "repository_id" {
  description = "Name of the Docker image to be stored in Artifact Registry"
  type        = string
  default = "fastapi-app" 
}

variable "region" {
  description = "The region for GCP resources"
  type        = string
  default     = "us-central1"
}

# variable "db_password" {
#   description = "PostgreSQL database password"
#   type        = string
#   sensitive   = true
# }

# variable "db_instance_name" {
#   description = "Name of the Cloud SQL instance"
#   type        = string
#   default     = "taskpulse-db"
# }

# variable "db_user" {
#   description = "PostgreSQL database username"
#   type        = string
#   default     = "taskpulse_user"
# }

# variable "pubsub_topic_name" {
#   description = "Name of the Pub/Sub topic"
#   type        = string
#   default     = "taskpulse-topic"
# }

# variable "pubsub_subscription_name" {
#   description = "Name of the Pub/Sub subscription"
#   type        = string
#   default     = "taskpulse-subscription"
# }
