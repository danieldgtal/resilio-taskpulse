
########################################
# outputs.tf
########################################
output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "db_instance_connection_name" {
  description = "Connection name of the PostgreSQL instance"
  value       = google_sql_database_instance.default.connection_name
}

output "db_instance_ip" {
  description = "IP address of the PostgreSQL instance"
  value       = google_sql_database_instance.default.ip_address[0].ip_address
}

output "pubsub_topic" {
  description = "The name of the Pub/Sub topic"
  value       = google_pubsub_topic.taskpulse.name
}

output "pubsub_subscription" {
  description = "The name of the Pub/Sub subscription"
  value       = google_pubsub_subscription.taskpulse_sub.name
}
