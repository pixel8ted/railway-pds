#!/bin/bash
# Script to check the status of a Bluesky PDS deployment

# Check if domain was provided
if [ $# -eq 0 ]; then
  echo "Usage: check-status.sh <domain>"
  echo "Example: check-status.sh example.com"
  exit 1
fi

DOMAIN=$1

echo "Checking PDS status for $DOMAIN..."

# Check if curl is available
if ! command -v curl &> /dev/null; then
  echo "Error: curl is not installed. This script requires curl to check the PDS status."
  exit 1
fi

# Check health endpoint
echo -n "Health check: "
health_response=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN/xrpc/_health")
if [ "$health_response" = "200" ]; then
  echo "OK"
  
  # Get version if jq is available
  if command -v jq &> /dev/null; then
    version=$(curl -s "https://$DOMAIN/xrpc/_health" | jq -r '.version')
    echo "PDS Version: $version"
  else
    echo "PDS Version: Unknown (jq not installed)"
    # Try a simple grep as fallback
    version=$(curl -s "https://$DOMAIN/xrpc/_health" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$version" ]; then
      echo "PDS Version: $version"
    fi
  fi
else
  echo "FAILED (HTTP $health_response)"
fi

# Check WebSocket endpoint
echo -n "WebSocket check: "
ws_response=$(curl -s -o /dev/null -w "%{http_code}" -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Sec-WebSocket-Version: 13" -H "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==" "https://$DOMAIN/xrpc/com.atproto.sync.subscribeRepos")
if [ "$ws_response" = "101" ]; then
  echo "OK"
else
  echo "FAILED (HTTP $ws_response)"
fi

echo ""
echo "For a more thorough WebSocket test, install wsdump and run:"
echo "wsdump \"wss://$DOMAIN/xrpc/com.atproto.sync.subscribeRepos?cursor=0\"" 