# --------- Build stage ---------
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies for npm
RUN npm install

# Copy all source code
COPY . .

# Build the app (creates dist/)
RUN npm run build

# --------- Nginx runtime stage ---------
FROM nginx:alpine

# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built static files to Nginx html folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy optional custom Nginx config if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
