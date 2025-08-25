# === STAGE 1: Build ===
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the app
RUN npm run build


# === STAGE 2: Production Runtime ===
FROM node:18-alpine AS runner

# Create app directory and set ownership
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs && \
    mkdir -p /app && \
    chown nextjs:nodejs /app

WORKDIR /app

# Copy files as root, but ensure they're accessible
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json
COPY --from=builder --chown=nextjs:nodejs /app/package-lock.json ./package-lock.json

# Switch to non-root user
USER nextjs:nodejs

# Now this will work — user owns /app
RUN npm ci --only=production

EXPOSE 3000

ENV NODE_ENV=production

CMD ["npm", "start"]