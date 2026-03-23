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
