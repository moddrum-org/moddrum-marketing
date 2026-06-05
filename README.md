# Moddrum AI - Marketing Website

This container serves the static marketing/sales website for Moddrum AI.

## Architecture

```
Browser → nginx (443/80)
         ├── /api/*           → backend (3001)
         ├── /app/*, /admin/* → frontend (3000)
         ├── /login, /signup  → frontend (3000)
         └── /*               → marketing (3002) ← THIS CONTAINER
```

## Development

The marketing site runs on port **3002** (host) → 3000 (container).

### Container commands
```bash
# Build and start with docker-compose
docker-compose -f docker-compose.dev.yml up -d --build marketing

# View logs
docker logs doc-processor-marketing-dev -f

# Rebuild after content changes
docker-compose -f docker-compose.dev.yml up -d --build marketing
```

## Content Source

The marketing site content is generated using **Stitch MCP** (AI website builder).
Generated files should be placed in the `public/` folder.

### File structure
```
marketing/
├── Dockerfile          # Container config
├── README.md           # This file
└── public/             # Static files served by container
    ├── index.html      # Homepage
    ├── pricing.html    # Pricing page (future)
    ├── features.html   # Features page (future)
    ├── css/            # Stylesheets
    ├── js/             # JavaScript
    └── images/         # Images and assets
```

## Links Between Sites

The "Login" button on the marketing site links to `/login`, which nginx routes to the frontend app.

```html
<a href="/login">Login</a>  <!-- nginx → frontend:3000 -->
```

## Production Deployment

Production deploys from `main` via `.github/workflows/deploy.yml` directly to the DigitalOcean droplet.
That makes `main` a production branch, not a casual content branch.

### Production network requirement
The marketing container must be reachable from the production nginx container on Docker network `moddrum_moddrum-network` with alias `marketing`.
The deploy workflow now verifies this after every restart.

### Post-deploy checks
After a deploy, these checks must pass on the droplet:

```bash
# Container is running
docker inspect moddrum-marketing --format '{{.State.Running}}'

# Container is attached to the production compose network
docker inspect moddrum-marketing --format '{{json .NetworkSettings.Networks}}'

# nginx can reach the upstream by alias
docker exec moddrum-proxy sh -lc "wget -qSO- http://marketing:3000/ 2>&1 | head -20"

# Public site is live
curl -I https://moddrum.com
```

### Known 502 recovery
If `moddrum.com` returns `502 Bad Gateway` while `moddrum-marketing` is running, first check whether the container is missing from `moddrum_moddrum-network`.
The fastest manual recovery is:

```bash
docker network connect --alias marketing moddrum_moddrum-network moddrum-marketing
```

Then verify both the proxy path and the public route again.
