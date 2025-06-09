#!/bin/bash

# Define your FastAPI app namespace and deployment name
APP_NAMESPACE="default" # Or your actual namespace if different
APP_DEPLOYMENT="fastapi-app"

echo "Finding a running pod for deployment: ${APP_DEPLOYMENT} in namespace: ${APP_NAMESPACE}..."

# Get the name of a running FastAPI pod
POD_NAME=$(kubectl get pods -n ${APP_NAMESPACE} -l app.kubernetes.io/name=${APP_DEPLOYMENT} -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD_NAME" ]; then
  echo "Error: No running pod found for deployment ${APP_DEPLOYMENT} in namespace ${APP_NAMESPACE}."
  exit 1
fi

echo "Selected pod to kill: ${POD_NAME}"
echo "Deleting pod ${POD_NAME}..."

# Delete the pod
kubectl delete pod "${POD_NAME}" -n "${APP_NAMESPACE}"

echo "Pod deletion initiated. Kubernetes should spin up a new one if replicas > 1."

echo "Waiting for 10 seconds for Kubernetes to react..."
sleep 10

echo "Checking pod status after deletion:"
kubectl get pods -n ${APP_NAMESPACE} -l app.kubernetes.io/name=${APP_DEPLOYMENT}

echo "Observe your Grafana dashboards and Prometheus alerts for impact and recovery."