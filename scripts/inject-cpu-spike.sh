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

echo "Selected pod: ${POD_NAME}"
echo "Injecting CPU spike into pod ${POD_NAME} for 30 seconds..."

# Execute a CPU-intensive loop inside the pod's container in the background
# This command finds the main container in the pod.
# If your app has multiple containers, you might need to specify --container <container-name>
kubectl exec -n ${APP_NAMESPACE} "${POD_NAME}" -- /bin/bash -c "echo 'Starting CPU spike (pid $$)'; while true; do :; done & sleep 30; kill $$" &

SPIKE_PID=$! # Store the PID of the background kubectl exec command
echo "CPU spike initiated. Monitoring for 30 seconds..."

# Watch logs or metrics here if you want to observe the spike effect
# Example: kubectl top pod ${POD_NAME} -n ${APP_NAMESPACE}

sleep 30

echo "CPU spike duration finished. Killing the background process if still running..."
# The `kill $$` inside the pod should clean it up, but this is a safeguard for the local script
kill $SPIKE_PID 2>/dev/null || true # Kill the kubectl exec process
echo "CPU spike injection attempt completed."

# Optional: You can check the pod's status or metrics after this
# kubectl describe pod "${POD_NAME}" -n ${APP_NAMESPACE}
# kubectl top pod "${POD_NAME}" -n ${APP_NAMESPACE}

echo "Observe your Grafana dashboards (FastAPI Overview) and Prometheus alerts for impact.."