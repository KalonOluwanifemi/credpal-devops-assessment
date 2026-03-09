# Stage 1
FROM node:18-alpine AS builder

WORKDIR /app

COPY app/package*.json ./

RUN npm install --only=production

COPY app .

# Stage 2
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app /app

RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup

USER nodeuser

EXPOSE 3000

CMD ["node", "src/index.js"]
