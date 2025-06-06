#!/bin/bash

# Set your GCP project ID
PROJECT_ID="gcp-learn-102"
SERVICE_ACCOUNT_NAME="terraform-gke-admin"
BUCKET_NAME="${PROJECT_ID}-terraform-state"  # Common naming convention

# Enable necessary APIs
gcloud services enable \
  container.googleapis.com \
  compute.googleapis.com \
  iam.googleapis.com \
  storage.googleapis.com

# Create the service account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --description="Service account for Terraform to manage GKE" \
  --display-name="Terraform GKE Admin"
# Create and download the service account key
mkdir -p credentials

gcloud iam service-accounts keys create "credentials/terraform-gke-key.json" \
  --iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

echo "\n✅ Terraform GKE Service Account created and key saved to credentials/terraform-gke-key.json"

# Grant necessary IAM roles
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/viewer"

# Storage Admin for tfstate in GCS
gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
 --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"


# Create Cloud Storage bucket for Terraform state in your desired region (e.g., us-central1)
echo "Creating Cloud Storage bucket for Terraform state: gs://$BUCKET_NAME"
gsutil mb -l us-central1 gs://$BUCKET_NAME

# Enable versioning on the bucket (highly recommended for Terraform state)
gsutil versioning set on gs://$BUCKET_NAME
echo "Versioning enabled on gs://$BUCKET_NAME"