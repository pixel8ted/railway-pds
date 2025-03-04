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

### 3. Configure DNS

After deployment, Railway will provide you with an IP address. You'll need to set up the following DNS records:

| Name | Type | Value | TTL |
|------|------|-------|-----|
| example.com | A | [Railway IP] | 600 |
| *.example.com | A | [Railway IP] | 600 |

The wildcard record is required for user subdomains.

### 4. Create your first account

Once deployed, you can create your first account by:

1. Accessing the Railway shell for your service
2. Running the command: `pdsadmin account create`

Or create an invite code with:
```
pdsadmin create-invite-code
```

### 5. Connect with the Bluesky app

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

## Resources

- [Bluesky PDS GitHub Repository](https://github.com/bluesky-social/pds)
- [AT Protocol Documentation](https://atproto.com/docs)
- [AT Protocol PDS Admins Discord](https://discord.gg/ATProtocolFoundation)

## License

This template is based on the Bluesky PDS, which is dual-licensed under MIT and Apache 2.0 terms. 