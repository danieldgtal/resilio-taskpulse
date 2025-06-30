#!/bin/bash

# --- Configuration ---
APP_NAMESPACE="default" # Your FastAPI app's Kubernetes namespace. IMPORTANT: Adjust if different.
APP_DEPLOYMENT="fastapi-app" # Your FastAPI app's deployment name

# --- Script Logic ---

echo "--- Initiating Container Restart Test (Minimal Container) ---"
echo "Targeting deployment: ${APP_DEPLOYMENT} in namespace: ${APP_NAMESPACE}"

# Get the name of a running FastAPI pod
echo "Finding a running pod..."
POD_NAME=$(kubectl get pods -n "${APP_NAMESPACE}" -l app.kubernetes.io/name="${APP_DEPLOYMENT}" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$POD_NAME" ]; then
    echo "Error: No running pod found for deployment '${APP_DEPLOYMENT}' in namespace '${APP_NAMESPACE}'."
    echo "Please ensure your FastAPI app is deployed and running."
    exit 1
fi

echo "Selected pod to induce restart: ${POD_NAME}"

# Step 1: Try to read the command line of PID 1 to confirm what's running
echo "Attempting to read PID 1's command line inside the container (e.g., to confirm FastAPI process)..."
# Using 'tr' to replace nulls with spaces for human readability
PID1_CMDLINE=$(kubectl exec -it "${POD_NAME}" -n "${APP_NAMESPACE}" -- cat /proc/1/cmdline 2>/dev/null | tr '\0' ' ')

if [ -z "$PID1_CMDLINE" ]; then
    echo "Warning: Could not read /proc/1/cmdline. 'cat' might be missing or /proc/1/cmdline doesn't exist."
    echo "This container is extremely minimal. Proceeding with direct kill attempt on PID 1 without confirmation of cmdline."
    # We will still try to kill PID 1, as it's the most common scenario for the main app process.
else
    echo "Confirmed PID 1's command line: '${PID1_CMDLINE}'"
    echo "This is likely your FastAPI application. Proceeding to kill PID 1."
fi

# Step 2: Attempt to kill PID 1 directly
echo "Attempting to kill PID 1 inside pod '${POD_NAME}' to force container restart..."
# Try 'kill 1' directly first, then 'sh -c 'kill 1'' if 'kill' isn't in PATH
if kubectl exec -it "${POD_NAME}" -n "${APP_NAMESPACE}" -- kill 1; then
    echo "Successfully sent kill signal to PID 1 in pod '${POD_NAME}'."
    echo "Kubernetes should now restart the container within this pod."
elif kubectl exec -it "${POD_NAME}" -n "${APP_NAMESPACE}" -- sh -c 'kill 1'; then
    echo "Successfully sent kill signal to PID 1 in pod '${POD_NAME}' using 'sh -c'."
    echo "Kubernetes should now restart the container within this pod."
else
    echo "Error: Failed to kill PID 1 in pod '${POD_NAME}'. Neither 'kill 1' nor 'sh -c 'kill 1'' worked."
    echo "This indicates an extremely restrictive container. For testing restarts, you may need to:"
    echo "  1. Modify your container image to include basic utilities like 'ps' and 'pkill' (e.g., install 'procps' package if using Alpine/Debian slim)."
    echo "  2. OR, temporarily add a '/crash' endpoint to your FastAPI application that explicitly calls 'os._exit(1)' for testing purposes."
    exit 1
fi

echo "--- Verification Steps ---"
echo "1. Wait 10-20 seconds for Prometheus to scrape the updated metric."
echo "2. Go to your Prometheus UI (e.g., http://localhost:9090/graph) -> Graph tab."
echo "3. Enter the expression: kube_pod_container_status_restarts_total{container=\"${APP_DEPLOYMENT}\", namespace=\"${APP_NAMESPACE}\"}"
echo "4. Click 'Execute' and observe the graph. The line for the affected pod '${POD_NAME}' should jump up by 1."
echo "5. If the graph jumps, also check Prometheus UI -> Alerts tab for 'PodRestarted' alert."
echo "6. Finally, check your Alertmanager UI (e.g., http://localhost:9093/#/alerts) and your Slack channel for the notification."

echo "--- Script Finished ---"