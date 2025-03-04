#!/bin/bash
# Script to select the appropriate Dockerfile based on environment variables

# Check if USE_ALPINE_IMAGE is set to true
if [ "$USE_ALPINE_IMAGE" = "true" ]; then
  echo "Using Alpine-based Dockerfile..."
  cp Dockerfile.alpine Dockerfile
  echo "Dockerfile has been updated to use the Alpine-based image."
else
  echo "Using official PDS image..."
  # Ensure we're using the default Dockerfile
  if [ -f Dockerfile.original ]; then
    cp Dockerfile.original Dockerfile
    echo "Dockerfile has been restored to use the official PDS image."
  fi
fi 