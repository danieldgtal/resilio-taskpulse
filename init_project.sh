#!/bin/bash

# Create root project directory
PROJECT_NAME="resilio-taskpulse"
mkdir -p $PROJECT_NAME

# Navigate into project
cd $PROJECT_NAME

# Create top-level folders
mkdir -p app/{handlers,models,metrics}
mkdir -p terraform
mkdir -p charts
mkdir -p .github/workflows
mkdir -p dashboards
mkdir -p alerts
mkdir -p runbooks
mkdir -p docs

# Create a README.md with neutral, professional language
cat <<EOF > README.md
# Resilio – TaskPulse

TaskPulse is a lightweight cloud-native task management service designed to demonstrate resilient service design, modern observability practices, and scalable infrastructure management.

This project includes:

- A Python-based backend microservice
- Infrastructure provisioning using Terraform
- Container orchestration using Kubernetes
- Monitoring and alerting stack using Prometheus and Grafana
- GitHub Actions for continuous integration and deployment

## Getting Started

Refer to the \`docs/\` folder for setup instructions and operational details.

## License

This project is open-source and available under the MIT License.
EOF

# Create a placeholder for initial runbook
cat <<EOF > runbooks/incident-response.md
# Incident Response Guide

This document outlines initial incident handling steps, escalation policies, and diagnostic tips.

_TBD: To be updated as observability is configured and failure scenarios are defined._
EOF

# Create an empty GitHub Actions workflow
cat <<EOF > .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, dev ]
  pull_request:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
EOF

# Done
echo "✅ Project folder '$PROJECT_NAME' initialized with structure and README."
