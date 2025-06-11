# Resilio – TaskPulse

**TaskPulse** is a lightweight, cloud-native task management backend built to demonstrate modern SRE practices including infrastructure as code, GitOps, observability, and resilience engineering.

This proof-of-concept (PoC) project simulates a production-grade environment with scalable architecture, monitoring, alerting, and CI/CD automation.

---

## 🧩 Key Components

| Layer             | Tech Stack/Tools                                  | Purpose                                           |
|------------------|----------------------------------------------------|---------------------------------------------------|
| **Application**   | FastAPI (Python)                                   | Backend API for managing tasks                    |
| **Infrastructure**| Terraform                                          | Infrastructure as Code for GCP provisioning       |
| **CI/CD**         | GitHub Actions + Docker + Helm + GKE              | Build, push, and deploy with Helm to Kubernetes   |
| **Monitoring**    | Prometheus, Grafana, Alertmanager                  | Metrics collection, dashboards, alerting          |
| **Logging**       | (Placeholder for integration with Loki, etc.)      | Logs collection (future scope)                    |
| **Resilience**    | Kubernetes Probes + Custom Alert Rules             | Health checks, alerting rules for recovery        |
| **Chaos Testing** | Planned via stress/kill scripts (Future Milestone)| Simulate failures & validate system behavior      |

---

## 🚀 Features Implemented

### ✅ FastAPI Microservice
- Lightweight task management REST API
- Health check (`/health`) and Swagger docs (`/docs`) endpoints
- Exposes Prometheus metrics at `/metrics`

### ✅ Terraform Infrastructure
- Creates GKE cluster, service accounts, networking, and persistent storage
- Secrets managed via GitHub Actions and GCP IAM

### ✅ CI/CD Pipeline (GitHub Actions)
- Infrastructure deployed with Terraform on `[infra]` commit
- Docker image built and pushed to GCP Artifact Registry
- Helm chart used to deploy FastAPI app to GKE
- Monitoring stack deployed using `kube-prometheus-stack`
- Post-deployment tests and notifications (Slack integration)

### ✅ Monitoring & Alerting
- Prometheus collects metrics from FastAPI, Kubernetes, etc.
- Grafana dashboard auto-provisioned from config maps
- Custom Prometheus alert rules:
  - High CPU usage
  - High memory usage
  - Pod crash loops
  - Service unavailability
- Grafana exposed via LoadBalancer for public access

---

## 📁 Project Structure

resilio-taskpulse/
├── app/ # FastAPI application
├── terraform/ # Terraform configs (GKE, network, etc.)
├── helm/
│ └── fastapi-app/ # Helm chart for FastAPI deployment
├── monitoring/
│ ├── alerts/ # Custom Prometheus alerting rules (YAML)
│ └── dashboards/ # JSON dashboards for Grafana
├── .github/workflows/ # GitHub Actions CI/CD pipelines
└── README.md


---

## 📊 Observability Access

| Tool        | How to Access                                          |
|-------------|--------------------------------------------------------|
| **Grafana** | `http://<external-ip>` — port `80`, default user: `admin` |
| **Prometheus** | Run `kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090` and open `http://localhost:9090` |

---

## 🧪 Planned: Chaos Testing

Upcoming additions:
- Simulate pod failures (`kubectl delete pod`)
- Simulate CPU spikes or memory pressure (`stress-ng`)
- Verify alerts and recovery mechanisms
- Verify alerts on slack

---


## 🛠 Getting Started

1. **Clone the repository**  
   ```bash
   git clone https://github.com/your-org/resilio-taskpulse.git
   cd resilio-taskpulse

2. **Provision infrastructure manually (optional, requires access)**
  terraform -chdir=terraform init
  terraform -chdir=terraform apply

3. **Trigger CI/CD pipeline**
  Push changes to the dev branch and merge into main to trigger the deployment workflow.

  The pipeline will:

  Build and deploy the FastAPI application to GKE

  Deploy the monitoring stack (Prometheus + Grafana)

  Apply custom alerting rules and Grafana dashboards

  💡 To provision infrastructure automatically via CI, include [infra] in your commit message. If [infra] is not present, the infrastructure provisioning step will be skipped.

## 🔒 Secrets Required
  Make sure to configure the following GitHub secrets:

  GCP_PROJECT_ID

  GCP_SA_KEY

  GKE_CLUSTER_NAME

  GKE_ZONE

  DB_USER_SECRET

  DB_PASSWORD_SECRET

  GRAFANA_ADMIN_PASSWORD

  SLACK_WEBHOOK_URL (optional)