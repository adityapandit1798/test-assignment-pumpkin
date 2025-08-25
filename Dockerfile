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

WORKDIR /app

# Use minimal permissions
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy only necessary files from builder
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json

# Switch to non-root user
USER nextjs:nodejs

# Install only production dependencies
# (if you have separate devDependencies)
RUN npm ci --only=production

# Expose port
EXPOSE 3000

# Set production environment
ENV NODE_ENV=production

# Run the production server
CMD ["npm", "start"]