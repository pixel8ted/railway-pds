# Bluesky PDS on Railway

This template deploys a [Bluesky Personal Data Server (PDS)](https://github.com/bluesky-social/pds) on Railway. A PDS allows you to self-host your Bluesky social data and federate with the wider AT Protocol network.

## Features

- Automatic TLS certificate management
- WebSocket support for federation
- Persistent storage for your PDS data
- Auto-updates via Watchtower (optional)
- Easy account management

## Deployment Requirements

Before deploying this template, you'll need:

1. **A domain name** - You'll need a domain that you control to point to your PDS
2. **DNS configuration** - You'll need to set up DNS records for your domain

## How to Deploy

### 1. Click the Deploy on Railway button

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/bluesky-pds)

### 2. Configure your environment variables

Required variables:
- `DOMAIN` - Your domain name (e.g., `example.com`)
- `ADMIN_PASSWORD` - Password for the admin account
- `PDS_ADMIN_EMAIL` - Email for the admin account

Optional variables:
- `PDS_EMAIL_SMTP_URL` - SMTP URL for email verification (e.g., `smtps://username:password@smtp.example.com/`)
- `PDS_EMAIL_FROM_ADDRESS` - Email address to send from (e.g., `admin@example.com`)
- `ENABLE_AUTO_UPDATES` - Set to `true` to enable Watchtower auto-updates (default: `true`)
- `LOG_LEVEL` - Log level (default: `info`)
- `USE_ALPINE_IMAGE` - Set to `true` to use the Alpine-based image instead of the official PDS image (default: `false`)

### 3. Set up a Railway Volume for data persistence

To ensure your PDS data persists across deployments:

1. Go to your project in the Railway dashboard
2. Click on your PDS service
3. Navigate to the "Volumes" tab
4. Click "Add Volume"
5. Set the mount path to `/pds`
6. Choose an appropriate size for your volume (recommended: at least 5GB)
7. Click "Add"
8. Redeploy your service for the volume to take effect

### 4. Configure DNS

After deployment, Railway will provide you with an IP address. You'll need to set up the following DNS records:

| Name | Type | Value | TTL |
|------|------|-------|-----|
| example.com | A | [Railway IP] | 600 |
| *.example.com | A | [Railway IP] | 600 |

The wildcard record is required for user subdomains.

### 5. Create your first account

Once deployed, you can create your first account by:

1. Accessing the Railway shell for your service
2. Running the command: `pdsadmin account create`

Or create an invite code with:
```
pdsadmin create-invite-code
```

### 6. Connect with the Bluesky app

1. Get the Bluesky app (Web, iOS, or Android)
2. Enter your PDS URL (e.g., `https://example.com/`) when logging in

## Maintenance

### Updating your PDS

Updates are handled automatically if you've enabled Watchtower. If you need to manually update:

```
pdsadmin update
```

### Checking logs

You can view logs in the Railway dashboard.

## Troubleshooting

- **Health check**: Visit `https://example.com/xrpc/_health` to verify your PDS is running
- **WebSocket check**: Use a tool like `wsdump` to test WebSockets: `wsdump "wss://example.com/xrpc/com.atproto.sync.subscribeRepos?cursor=0"`

### Common Issues

#### Deployment Failures

If you encounter deployment failures related to missing commands or tools in the base image, you have two options:

1. Set the `USE_ALPINE_IMAGE` environment variable to `true` to use the Alpine-based image instead of the official PDS image
2. Manually switch to the Alpine-based Dockerfile:
   - Access the Railway shell for your service
   - Run the command: `./select-dockerfile.sh`
   - Redeploy your service

#### Volume Permissions

If you encounter permission issues with the volume:

1. Make sure the volume is properly mounted at `/pds`
2. You may need to adjust permissions in the Railway shell: `chmod -R 755 /pds`

## Resources

- [Bluesky PDS GitHub Repository](https://github.com/bluesky-social/pds)
- [AT Protocol Documentation](https://atproto.com/docs)
- [AT Protocol PDS Admins Discord](https://discord.gg/ATProtocolFoundation)
- [Railway Volumes Documentation](https://docs.railway.app/reference/volumes)

## License

This template is based on the Bluesky PDS, which is dual-licensed under MIT and Apache 2.0 terms. 