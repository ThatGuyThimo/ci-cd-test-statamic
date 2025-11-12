# Backend configuration for Terraform remote state stored in DigitalOcean Spaces (S3-compatible)
# This file should NOT be committed with secrets. Keep a copy locally or in CI secrets.

bucket         = "${TF_STATE_BUCKET}"
key            = "ci-cd-test-statamic/terraform.tfstate"
region         = "${TF_STATE_REGION}"
endpoint       = "${TF_STATE_ENDPOINT}"
access_key     = "${DO_SPACES_KEY}"
secret_key     = "${DO_SPACES_SECRET}"
skip_credentials_validation = true
skip_metadata_api_check     = true
force_path_style            = true
