#!/bin/bash
# Health check script for Bluesky PDS on Railway

# Check if the PDS is responding to health checks
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/xrpc/_health)

if [ "$response" = "200" ]; then
  exit 0
else
  exit 1
fi 