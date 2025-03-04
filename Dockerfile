FROM ghcr.io/bluesky-social/pds:latest

# Install additional tools using a more compatible approach
# First try apt-get (Debian/Ubuntu), then apk (Alpine), then yum (CentOS/RHEL)
RUN (command -v apt-get && apt-get update && apt-get install -y curl jq && rm -rf /var/lib/apt/lists/*) || \
    (command -v apk && apk add --no-cache curl jq) || \
    (command -v yum && yum install -y curl jq && yum clean all) || \
    echo "Warning: Could not install curl and jq. Some functionality may be limited."

# Copy our startup script and ensure it's executable
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh && \
    ls -la /usr/local/bin/start.sh && \
    echo "Startup script is ready"

# Expose ports
EXPOSE 3000

# Set the entrypoint with a shell to ensure proper execution
ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/start.sh"] 