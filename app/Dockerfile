# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
RUN apk update && apk upgrade --no-cache
COPY package*.json ./
RUN rm -rf node_modules package-lock.json && \
    npm install --omit=dev --no-audit --progress=false
COPY . .

# Stage 2: Run (Alpine)
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 80
CMD ["node", "server.js"]