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

# Create Cloud Storage bucket for Terraform state
echo "Creating Cloud Storage bucket for Terraform state..."
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

# Create Cloud Storage bucket for Terraform state
echo "Creating Cloud Storage bucket for Terraform state..."
gsutil mb -l us-central1 gs://$BUCKET_NAME

# Enable versioning on the bucket (recommended for tfstate)
gsutil versioning set on gs://$BUCKET_NAME

# Create and download the service account key
mkdir -p credentials

gcloud iam service-accounts keys create "credentials/terraform-gke-key.json" \
  --iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

echo "\n✅ Terraform GKE Service Account created and key saved to credentials/terraform-gke-key.json"
echo "✅ Cloud Storage bucket created: gs://$BUCKET_NAME"
echo "✅ Bucket versioning enabled for state file safety"

# Enable versioning on the bucket (recommended for tfstate)
gsutil versioning set on gs://$BUCKET_NAME

# Create and download the service account key
mkdir -p credentials

gcloud iam service-accounts keys create "credentials/terraform-gke-key.json" \
  --iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

echo "\n✅ Terraform GKE Service Account created and key saved to credentials/terraform-gke-key.json"
echo "✅ Cloud Storage bucket created: gs://$BUCKET_NAME"
echo "✅ Bucket versioning enabled for state file safety"