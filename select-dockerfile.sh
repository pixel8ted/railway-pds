#!/bin/sh
# Script to select the appropriate Dockerfile based on environment variables

echo "Dockerfile selection script running..."

# Check if Dockerfile.original exists, if not, create a backup
if [ ! -f Dockerfile.original ]; then
  echo "Creating backup of original Dockerfile..."
  cp Dockerfile Dockerfile.original
fi

# Check if USE_ALPINE_IMAGE is set to true
if [ "$USE_ALPINE_IMAGE" = "true" ]; then
  echo "Using Alpine-based Dockerfile..."
  if [ -f Dockerfile.alpine ]; then
    cp Dockerfile.alpine Dockerfile
    echo "Dockerfile has been updated to use the Alpine-based image."
  else
    echo "Error: Dockerfile.alpine not found!"
    exit 1
  fi
else
  echo "Using official PDS image..."
  # Ensure we're using the default Dockerfile
  if [ -f Dockerfile.original ]; then
    cp Dockerfile.original Dockerfile
    echo "Dockerfile has been restored to use the official PDS image."
  else
    echo "Warning: Dockerfile.original not found. Cannot restore original Dockerfile."
  fi
fi

# Verify the Dockerfile exists
if [ -f Dockerfile ]; then
  echo "Dockerfile is ready. You can now redeploy your service."
else
  echo "Error: Dockerfile not found after selection process!"
  exit 1
fi 