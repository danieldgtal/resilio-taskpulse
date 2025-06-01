

########################################
# main.tf
########################################

# Create GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
  }
}

# Create PostgreSQL Instance
resource "google_sql_database_instance" "default" {
  name             = var.db_instance_name
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro"
  }
}

# Create User
resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.default.name
  password_wo = var.db_password
}

# Create DB
resource "google_sql_database" "db" {
  name     = "taskpulse"
  instance = google_sql_database_instance.default.name
}


# Pub/Sub Topic
resource "google_pubsub_topic" "taskpulse" {
  name = var.pubsub_topic_name
}

# Pub/Sub Subscription
resource "google_pubsub_subscription" "taskpulse_sub" {
  name  = var.pubsub_subscription_name
  topic = google_pubsub_topic.taskpulse.name
}

# Enable Required Services
# resource "google_project_service" "required_services" {
#   for_each = toset([
#     "container.googleapis.com",
#     "sqladmin.googleapis.com",
#     "pubsub.googleapis.com"
#   ])
#   service = each.key
#   disable_on_destroy = false
# }
