# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Stage 2: Run (Distroless)
FROM gcr.io/distroless/nodejs18
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 80
CMD ["server.js"]