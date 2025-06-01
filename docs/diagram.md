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

## Instruction 
### Designer Instructions (Tell Them This)
"Please trace this architecture using GCP icons in Draw.io. Include GKE, Cloud SQL, Pub/Sub, GitHub Actions CI/CD flow, and Monitoring stack with Prometheus + Grafana. Reference ports (80 → 8000), show connections between components, and label all arrows and infrastructure as per the diagram. You can pull details from my repo (k8s/, .github/workflows/, and charts/)."

Possible prompt: Would you like me to generate a Draw.io diagram file (XML) or PNG preview from this sketch as well, or do you want to leave that to the designer entirely?