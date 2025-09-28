# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app

# Install deps
COPY package*.json ./
RUN if [ -f package-lock.json ]; then \
      npm ci --only=production --no-audit --progress=false; \
    else \
      npm install --production --no-audit --progress=false; \
    fi \
    && npm install cross-spawn@7.0.5 --no-save

# Copy source
COPY . .

# Stage 2: Run
FROM node:18-alpine AS stage-1
WORKDIR /app
COPY --from=builder /app .
CMD ["node", "server.js"]