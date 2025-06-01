# 🧠 Taskpulse Microservice Architecture - GCP Kubernetes Deployment

                                     ┌─────────────────────┐
                                     │     End Users       │
                                     └────────┬────────────┘
                                              │
                                              ▼
                                ┌──────────────────────────────┐
                                │ LoadBalancer Service         │
                                │ (taskpulse-api: Port 80)     │
                                └────────┬─────────────────────┘
                                         │
                                         ▼
                               ┌──────────────────────────────┐
                               │ GKE Pods (taskpulse-api)     │
                               │ Docker Image from GCR        │
                               │ Port 8000 (HTTP target)      │
                               └───────┬─────────────┬────────┘
                                       │             │
                                       │             │
     ┌────────────────────────┐        │             │       ┌────────────────────────┐
     │ Google Cloud SQL       │◄───────┘             └──────►│ Google Pub/Sub         │
     │ PostgreSQL             │                         ▲    │ - Topic                │
     │ Env: DB_HOST, USER...  │                         │    │ - Subscription         │
     └────────────────────────┘                         │    └────────────────────────┘
                                                       ▼
                                ┌────────────────────────────────┐
                                │ Monitoring Stack (via Helm)    │
                                │ Namespace: monitoring          │
                                │ - Prometheus + AlertManager    │
                                │ - Grafana (Port 3000)          │
                                └────────────────┬──────────────┘
                                                 │
                                                 ▼
                                ┌────────────────────────────────┐
                                │ Prometheus scrapes app metrics │
                                │ from /metrics endpoint via svc │
                                └────────────────────────────────┘

# 🛠 Infrastructure (Provisioned via Terraform)
- GKE Cluster
- Cloud SQL (PostgreSQL)
- Pub/Sub (topic + subscription)
- IAM Roles, Secrets
- VPC Networking

# 🔁 CI/CD Pipeline (GitHub Actions)

┌────────────────────────────────────────────┐
│ GitHub Repository                          │
│ ┌────────────────────────────────────────┐ │
│ │ .github/workflows/deploy.yml           │ │
│ │ ─ Triggers on push to main/dev         │ │
│ │ ─ Builds Docker image                  │ │
│ │ ─ Pushes to GCR                        │ │
│ │ ─ Applies K8s manifests via kubectl    │ │
│ │ ─ Installs Helm charts (monitoring)    │ │
│ └────────────────────────────────────────┘ │
└────────────────────────────────────────────┘

# 🔐 Secrets & Configs
- K8s Secret: taskpulse-secret (DB_USER, DB_PASSWORD)
- K8s ConfigMaps (if needed)
- Terraform output values passed to GitHub Actions

# 🔄 Networking & Observability
- Ingress via LoadBalancer (GKE external IP)
- Internal networking to Cloud SQL via IP allow
- Metrics available via Prometheus/Grafana

