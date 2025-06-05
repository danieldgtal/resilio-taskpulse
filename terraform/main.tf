

########################################
# main.tf
########################################

# Create GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
  }

  deletion_protection = false
}

# Create Artifact Registry Repository for Docker Images
resource "google_artifact_registry_repository" "docker_repo" {

  repository_id = var.repository_id         # or any name you want
  format        = "DOCKER"
  location      = var.region          # must be a REGION, not zone like us-central1-a
  project       = var.project_id  # replace with your actual project ID

  description = "Minimal Docker repo for FastAPI app"
}


# Create PostgreSQL Instance
# resource "google_sql_database_instance" "default" {
#   name             = var.db_instance_name
#   region           = var.region
#   database_version = "POSTGRES_14"

#   settings {
#     tier = "db-f1-micro"
#   }

#    deletion_protection = false

# }

# Create User
# resource "google_sql_user" "users" {
#   name     = var.db_user
#   instance = google_sql_database_instance.default.name
#   password = var.db_password
# }

# # Create DB
# resource "google_sql_database" "db" {
#   name     = "taskpulse"
#   instance = google_sql_database_instance.default.name
# }


# Pub/Sub Topic
# resource "google_pubsub_topic" "taskpulse" {
#   name = var.pubsub_topic_name
# }

# # Pub/Sub Subscription
# resource "google_pubsub_subscription" "taskpulse_sub" {
#   name  = var.pubsub_subscription_name
#   topic = google_pubsub_topic.taskpulse.name
# }

