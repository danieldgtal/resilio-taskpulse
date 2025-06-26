# 🧠 TaskPulse Microservice Architecture - GCP Kubernetes Deployment

## System Overview

The TaskPulse microservice follows a modern cloud-native architecture deployed on Google Cloud Platform (GCP) using Kubernetes Engine (GKE). The system handles web traffic through a load balancer, processes requests via Python microservices, and stores data in managed PostgreSQL database.

## Architecture Diagram

```
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
│  │ Google Pub/Sub (Topic + Subscription)  │ │
│  │ (Deployed via Terraform for PoC,       │ │
│  │  Not actively used by TaskPulse API)   │ │
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
```

## Components Overview

### Application Layer
- **TaskPulse API Pods**: Python microservice running on port 8000
- **Docker Images**: Stored in Google Artifact Registry.
- **Load Balancer**: GKE external IP service on port 80
- **Metrics Endpoint**: `/metrics` for Prometheus monitoring
- **Probe Endpoint**: '/healtz' for application probe check. 

### Data Layer
- **Cloud SQL**: Managed PostgreSQL database service
- **Google Pub/Sub**: Message queue (deployed for PoC, not actively used)

### Monitoring & Observability
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Alertmanager**: Alert routing and management
- **Notifications**: Slack and email alerts

## 🛠 Infrastructure (Provisioned via Terraform)

The entire infrastructure is managed as code using Terraform, including:

- **GKE Cluster**: Kubernetes cluster for container orchestration
- **Cloud SQL (PostgreSQL)**: Managed database service
- **Pub/Sub**: Topic and subscription for messaging
- **IAM Roles**: Service accounts and permissions
- **Secrets Management**: Secure storage of sensitive data
- **VPC Networking**: Network isolation and security

## 🔁 CI/CD Pipeline (GitHub Actions)

### Workflow Overview

```
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
```

### Pipeline Steps

1. **Trigger**: Automated on push to `main` or `dev` branches
2. **Build**: Creates Docker image from source code
3. **Push**: Uploads image to Google Container Registry
4. **Authenticate**: Uses Workload Identity for GCP access
5. **Deploy**: Applies Kubernetes manifests using kubectl
6. **Monitor**: Installs monitoring stack via Helm charts

## 🔐 Security & Configuration

### Secrets Management
- **Kubernetes Secrets**: `taskpulse-secret` containing database credentials
  - `DB_USER`: Database username
  - `DB_PASSWORD`: Database password
- **ConfigMaps**: Application configuration (as needed)
- **Terraform Outputs**: Infrastructure values passed to GitHub Actions

### Environment Variables
- `DB_HOST`: Cloud SQL instance connection string
- `DB_USER`: Database user (from Kubernetes secret)
- `DB_PASSWORD`: Database password (from Kubernetes secret)

## 🔄 Networking & Observability

### Network Architecture
- **External Access**: LoadBalancer service with GKE external IP
- **Internal Communication**: Pod-to-pod communication within cluster
- **Database Access**: Secure connection to Cloud SQL via IP allowlisting
- **VPC Isolation**: Network segmentation for security

### Monitoring Setup
- **Metrics Collection**: Prometheus scrapes `/metrics` endpoint
- **Visualization**: Grafana dashboards for system monitoring
- **Alerting**: Automated alerts via Slack and email
- **Health Checks**: Kubernetes liveness and readiness probes

## Deployment Flow

1. **Code Changes**: Developers push code to GitHub repository
2. **CI Trigger**: GitHub Actions workflow automatically starts
3. **Image Build**: Docker image built and pushed to GCR
4. **Infrastructure**: Terraform manages underlying GCP resources
5. **Deployment**: Kubernetes manifests applied to GKE cluster
6. **Monitoring**: Observability stack monitors application health
7. **Alerts**: Notifications sent for any issues or anomalies

## Key Benefits

- **Scalability**: Kubernetes provides automatic scaling capabilities
- **Reliability**: Managed services reduce operational overhead
- **Security**: IAM roles and secrets management ensure secure access
- **Observability**: Comprehensive monitoring and alerting
- **Automation**: Fully automated CI/CD pipeline
- **Infrastructure as Code**: Reproducible and version-controlled infrastructure
