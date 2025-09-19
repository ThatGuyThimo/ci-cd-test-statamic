#!/bin/sh
set -e

# Start MinIO in background
/usr/bin/minio server /data --console-address ":8900" &

# Wait until MinIO is reachable
until curl -s http://127.0.0.1:9000/minio/health/ready > /dev/null; do
  echo "Waiting for MinIO to be ready..."
  sleep 1
done

# Configure mc alias
mc alias set local http://127.0.0.1:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"

# Create bucket if env is set
if [ -n "$AWS_BUCKET" ]; then
  mc mb --ignore-existing "local/$AWS_BUCKET"
  echo "✅ Created bucket: $AWS_BUCKET"
else
  echo "⚠️  AWS_BUCKET is not set, skipping bucket creation"
fi

# Bring MinIO back to foreground
wait
