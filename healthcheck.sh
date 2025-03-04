#!/bin/bash
# Health check script for Bluesky PDS on Railway

# Check if curl is available
if ! command -v curl &> /dev/null; then
  echo "Warning: curl is not installed. Using alternative health check method."
  # Try to connect to the port directly
  if nc -z localhost 3000; then
    exit 0
  else
    exit 1
  fi
fi

# If curl is available, use it for the health check
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/xrpc/_health)

if [ "$response" = "200" ]; then
  exit 0
else
  exit 1
fi 