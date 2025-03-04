FROM ghcr.io/bluesky-social/pds:latest

# Install additional tools needed for Railway
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Copy our startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose ports
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/start.sh"] 