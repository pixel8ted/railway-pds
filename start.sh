#!/bin/bash
set -e

# Check for required environment variables
if [ -z "$DOMAIN" ]; then
  echo "Error: DOMAIN environment variable is required"
  exit 1
fi

if [ -z "$ADMIN_PASSWORD" ]; then
  echo "Error: ADMIN_PASSWORD environment variable is required"
  exit 1
fi

# Create data directory if it doesn't exist
mkdir -p /pds/data
mkdir -p /pds/data/blobs

# Set proper permissions for the data directory
chmod -R 755 /pds

# Create the PDS environment file
cat > /pds/pds.env << EOF
PDS_HOSTNAME=${DOMAIN}
PDS_JWT_SECRET=$(openssl rand -hex 32)
PDS_ADMIN_PASSWORD=${ADMIN_PASSWORD}
PDS_ADMIN_EMAIL=${PDS_ADMIN_EMAIL:-admin@${DOMAIN}}
PDS_DATA_DIRECTORY=/pds/data
PDS_BLOBSTORE_DISK_LOCATION=/pds/data/blobs
PDS_DID_PLC_URL=https://plc.directory
PDS_BSKY_APP_VIEW_URL=https://api.bsky.app
PDS_BSKY_APP_VIEW_DID=did:web:api.bsky.app
PDS_REPORT_SERVICE_URL=https://mod.bsky.app
PDS_REPORT_SERVICE_DID=did:plc:ar7c4by46qjdydhdevvrndac
PDS_HANDLE_RESOLVE_KEY=
PDS_CRAWLERS=https://bsky.network
PDS_BGS=https://bsky.network
EOF

# Add optional SMTP configuration if provided
if [ ! -z "$PDS_EMAIL_SMTP_URL" ]; then
  echo "PDS_EMAIL_SMTP_URL=${PDS_EMAIL_SMTP_URL}" >> /pds/pds.env
fi

if [ ! -z "$PDS_EMAIL_FROM_ADDRESS" ]; then
  echo "PDS_EMAIL_FROM_ADDRESS=${PDS_EMAIL_FROM_ADDRESS}" >> /pds/pds.env
fi

# Add optional log level if provided
if [ ! -z "$LOG_LEVEL" ]; then
  echo "LOG_LEVEL=${LOG_LEVEL}" >> /pds/pds.env
fi

# Configure Caddy for TLS
cat > /pds/Caddyfile << EOF
{
  email ${PDS_ADMIN_EMAIL:-admin@${DOMAIN}}
}

${DOMAIN}, *.${DOMAIN} {
  reverse_proxy localhost:3000
}
EOF

# Print startup message
echo "Starting Bluesky PDS for domain: ${DOMAIN}"
echo "Data will be stored in /pds directory (ensure a Railway volume is mounted here)"

# Start Caddy in the background
caddy run --config /pds/Caddyfile --adapter caddyfile &

# Start the PDS
cd /pds
source /pds/pds.env
exec node /app/index.js 