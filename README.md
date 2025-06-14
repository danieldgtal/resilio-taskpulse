# Resilio – TaskPulse

**TaskPulse** is a production-grade, cloud-native SRE project that demonstrates resilient architecture, automated infrastructure, and comprehensive observability at scale. It simulates a real-world task management backend deployed on Google Kubernetes Engine (GKE), showcasing modern Site Reliability Engineering (SRE) principles and DevOps practices.

This project includes:

- Infrastructure as Code with **Terraform** (GKE, CloudSQL, VPC)
- CI/CD automation using **GitHub Actions** with conditional workflows
- A scalable **FastAPI** microservice containerized and deployed via **Helm**
- End-to-end monitoring using **Prometheus**, **Alertmanager**, and **Grafana**
- Application-level metrics exposed through a custom `/metrics` endpoint
- Custom **Prometheus alert rules** and curated **Grafana dashboards**
- Real-time **Slack notifications** for deployment status and system alerts
- **Implemented Chaos Testing**: Bash-based scripts to simulate pod deletion and CPU spikes for resilience verification
- Service-oriented deployment model aligned with **12-factor app** and **SRE** principles

The architecture and tooling reflect the kind of production-readiness expected in enterprise environments like **Loblaw**, emphasizing performance, scalability, reliability, and operational excellence.


---

## 🧩 Key Components

| Layer | Tech Stack/Tools | Purpose |
|---|---|---|
| **Application** | FastAPI (Python) | Backend API for managing tasks |
| **Infrastructure**| Terraform | Infrastructure as Code for GCP provisioning |
| **CI/CD** | GitHub Actions + Docker + Helm + GKE | Build, push, and deploy with Helm to Kubernetes |
| **Monitoring** | Prometheus, Grafana, Alertmanager | Metrics collection, dashboards, alerting |
| **Logging** | (Placeholder for integration with Loki, etc.) | Logs collection (future scope) |
| **Resilience** | Kubernetes Probes + Custom Alert Rules | Health checks, alerting rules for recovery |
| **Chaos Testing** | Bash + kubectl (Implemented) | Simulate failures & validate system behavior |

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

## 🧪 Chaos Testing

**Implemented Features:**

* **Pod Failure Simulation:** Successfully simulated pod failures using `kubectl delete pod` commands, observing Kubernetes' rapid self-healing capabilities (new pods automatically spun up).
* **CPU Spike Injection:** Injected controlled CPU spikes into application pods using custom Bash scripts and `kubectl exec` to stress test resource utilization.
* **Recovery Mechanism Verification:** Verified the system's recovery mechanisms by monitoring pod recreation, service availability, and performance metrics in Grafana during and after failure injections.
* **Grafana Dashboard Validation:** Confirmed that custom Grafana dashboards accurately visualized the impact of chaos events on key metrics, including CPU usage spikes, transient dips in request rates, and temporary increases in latency/errors.
* **Alerting Rule Testing:** Tested the configured Prometheus alerting rules and gained a clearer understanding of their triggering conditions (e.g., `for:` durations) for sending notifications to Slack.

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

| Tool | How to Access |
|---|---|
| **Grafana** | `http://<external-ip>` — port `80`, default user: `admin` |
| **Prometheus** | Run `kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090` and open `http://localhost:9090` |

---


## 🛠 Getting Started

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/your-org/resilio-taskpulse.git](https://github.com/your-org/resilio-taskpulse.git)
    cd resilio-taskpulse
    ```
2.  **Provision infrastructure manually (optional, requires access)**
    ```bash
    terraform -chdir=terraform init
    terraform -chdir=terraform apply
    ```
3.  **Trigger CI/CD pipeline**
    Push changes to the dev branch and merge into main to trigger the deployment workflow.

    The pipeline will:

    * Build and deploy the FastAPI application to GKE
    * Deploy the monitoring stack (Prometheus + Grafana)
    * Apply custom alerting rules and Grafana dashboards

    💡 To provision infrastructure automatically via CI, include `[infra]` in your commit message. If `[infra]` is not present, the infrastructure provisioning step will be skipped.

## 🔒 Secrets Required
Make sure to configure the following GitHub secrets:

* GCP_PROJECT_ID
* GCP_SA_KEY
* GKE_CLUSTER_NAME
* GKE_ZONE
* DB_USER_SECRET
* DB_PASSWORD_SECRET
* GRAFANA_ADMIN_PASSWORD
* SLACK_WEBHOOK_URL (optional)