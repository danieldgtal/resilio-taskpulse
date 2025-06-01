# 🧠 Taskpulse Microservice Architecture - GCP Kubernetes Deployment
┌──────────────────────────────────────────────┐
│                  End Users                   │
└─────────────────────┬────────────────────────┘
                      │ Internet Traffic (HTTPS)
                      ▼
┌──────────────────────────────────────────────┐
│ LoadBalancer Service (GKE External IP)       │
│    (taskpulse-api: Port 80)                  │
└─────────────────────┬────────────────────────┘
                      │ Routes Traffic
                      ▼
┌──────────────────────────────────────────────┐
│ GKE Cluster (Google Kubernetes Engine)       │
│                                              │
│  ┌─────────────────────────────────────────┐ │
│  │ TaskPulse API Pods                      │ │
│  │   (Python Microservice)                 │ │
│  │   (Docker Image from Google Container   │ │
│  │    Registry)                            │ │
│  │   (Internal Port: 8000)                 │ │
│  │   (/metrics Endpoint for Monitoring)    │ │
│  └────────┬───────────────────┬────────────┘ │
│           │                   │              │
│           │ DB Connection     │ Metrics Scrape (HTTP)
│           ▼                   ▼              │
│  ┌────────────────────────┐  ┌──────────────┐ │
│  │ Cloud SQL (PostgreSQL) │  │ Monitoring   │ │
│  │ (Managed Database Service)│ │ Stack        │ │
│  │ (e.g., DB_HOST, USER envs)│ │ (Prometheus, │ │
│  └────────────────────────┘  │  Grafana,    │ │
│                               │  Alertmanager)│ │
│                               └───────┬──────┘ │
│                                       │ Alerts
│                                       ▼        │
│                                  Slack / Email │
│                                                │
│  ┌─────────────────────────────────────────┐ │
│  │ Google Pub/Sub (Topic + Subscription) │ │
│  │ (Deployed via Terraform for PoC,        │ │
│  │  Not actively used by TaskPulse API)    │ │
│  └─────────────────────────────────────────┘ │
└───────────────────────────▲──────────────────┘
                            │ Provisioned & Managed By
                            │
┌───────────────────────────┴───────────────────┐
│ Infrastructure Provisioning (Terraform)       │
│ (Manages GKE Cluster, Cloud SQL, Pub/Sub,     │
│  IAM Roles, VPC Networking, Secrets)          │
└───────────────────────────┬───────────────────┘
                            │ Deployed & Updated By
                            ▼
┌──────────────────────────────────────────────┐
│ CI/CD Pipeline (GitHub Actions)              │
│ ┌──────────────────────────────────────────┐ │
│ │ GitHub Repository                        │ │
│ │  (Source Code, K8s Manifests, Helm Charts)│ │
│ └─────────┬────────────────────────────────┘ │
│           │ Push to main/dev branch          │
│           ▼                                  │
│ ┌──────────────────────────────────────────┐ │
│ │ GitHub Actions Workflow                  │ │
│ │ - Build Docker Image                     │ │
│ │ - Push to GCR                            │ │
│ │ - Authenticate to GCP (Workload Identity)│ │
│ │ - Apply Kubernetes Manifests (kubectl)   │ │
│ │ - Install Monitoring Helm Charts (Helm)  │ │
│ └──────────────────────────────────────────┘ │
└──────────────────────────────────────────────┘
           └────────────────────────────┘


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

