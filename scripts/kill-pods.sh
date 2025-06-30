#!/bin/bash

# --- Configuration ---
APP_NAMESPACE="default" # Your FastAPI app's Kubernetes namespace
APP_DEPLOYMENT="fastapi-app" # Your FastAPI app's deployment name
# Adjust the PROCESS_NAME based on how your FastAPI app is run inside the container
# Common examples: uvicorn, gunicorn, python
PROCESS_NAME="uvicorn" 

# --- Script Logic ---

echo "--- Initiating Container Restart Test ---"
echo "Targeting deployment: ${APP_DEPLOYMENT} in namespace: ${APP_NAMESPACE}"
echo "Assuming main application process name is: ${PROCESS_NAME}"

# Get the name of a running FastAPI pod
echo "Finding a running pod..."
POD_NAME=$(kubectl get pods -n "${APP_NAMESPACE}" -l app.kubernetes.io/name="${APP_DEPLOYMENT}" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$POD_NAME" ]; then
    echo "Error: No running pod found for deployment '${APP_DEPLOYMENT}' in namespace '${APP_NAMESPACE}'."
    echo "Please ensure your FastAPI app is deployed and running."
    exit 1
fi

echo "Selected pod to induce restart: ${POD_NAME}"

# Attempt to find and kill the main process inside the container
echo "Attempting to kill '${PROCESS_NAME}' process inside pod '${POD_NAME}'..."
if kubectl exec -it "${POD_NAME}" -n "${APP_NAMESPACE}" -- pkill -f "${PROCESS_NAME}"; then
    echo "Successfully sent kill signal to '${PROCESS_NAME}' process in pod '${POD_NAME}'."
    echo "Kubernetes should now restart the container within this pod."
else
    echo "Warning: Could not kill '${PROCESS_NAME}' directly using pkill (process not found or pkill not available)."
    echo "Attempting alternative: find PID and kill."
    MAIN_PID=$(kubectl exec -it "${POD_NAME}" -n "${APP_NAMESPACE}" -- ps aux | grep -v grep | grep "${PROCESS_NAME}" | awk '{print $2}' | head -n 1)

    if [ -z "$MAIN_PID" ]; then
        echo "Error: Could not find main process (PID) for '${PROCESS_NAME}' in pod '${POD_NAME}' using 'ps aux'."
        echo "Please verify the 'PROCESS_NAME' variable in the script or check container contents manually with 'kubectl exec -it ${POD_NAME} -- ps aux'."
        exit 1
    fi

    echo "Found PID: ${MAIN_PID} for '${PROCESS_NAME}'."
    if kubectl exec -it "${POD_NAME}" -n "${APP_NAMESPACE}" -- kill "${MAIN_PID}"; then
        echo "Successfully sent kill signal to PID ${MAIN_PID} in pod '${POD_NAME}'."
        echo "Kubernetes should now restart the container within this pod."
    else
        echo "Error: Failed to kill process with PID ${MAIN_PID} in pod '${POD_NAME}'."
        exit 1
    fi
fi

echo "--- Verification Steps ---"
echo "1. Wait 10-20 seconds for metrics to update."
echo "2. Go to your Prometheus UI -> Graph tab."
echo "3. Enter the expression: kube_pod_container_status_restarts_total{container=\"${APP_DEPLOYMENT}\", namespace=\"${APP_NAMESPACE}\"}"
echo "4. Click 'Execute' and observe the graph. The line for '${POD_NAME}' should jump up by 1."
echo "5. Check Prometheus UI -> Alerts tab for 'PodRestarted' alert."
echo "6. Check your Alertmanager UI (if configured) and Slack channel for the notification."

echo "--- Script Finished ---"