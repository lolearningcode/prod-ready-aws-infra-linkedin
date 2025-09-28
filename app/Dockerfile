# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
RUN apk update && apk upgrade --no-cache
COPY package*.json ./
RUN if [ -f package-lock.json ]; then \
      npm ci --only=production; \
    else \
      npm install --omit=dev; \
    fi
COPY . .

# Stage 2: Run (Alpine)
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 80
CMD ["server.js"]