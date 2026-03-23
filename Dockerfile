# Marketing Website Container
# Lightweight static file server for the marketing/sales site

FROM node:20-alpine

WORKDIR /app

# Install serve for static file hosting
RUN npm install -g serve

# Copy static files directly into /app (serve . serves all subdirs as routes)
COPY public/ ./

# Expose port 3000 (mapped to 3002 on host)
EXPOSE 3000

# Serve all static files from /app (practice/ → /practice, etc.)
CMD ["serve", ".", "-l", "3000", "--no-clipboard"]
