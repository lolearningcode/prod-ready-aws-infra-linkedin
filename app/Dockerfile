# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app

# Upgrade npm inside container to match your local (>=10.9.0)
RUN npm install -g npm@10.9.2

# Copy dependency manifests first (for caching)
COPY package*.json ./

# Install deps with overrides support
RUN npm install --omit=dev --no-audit --progress=false

# Copy source
COPY . .

# Stage 2: Run
FROM node:18-alpine AS stage-1
WORKDIR /app
COPY --from=builder /app .
CMD ["node", "server.js"]