# Use Node.js to build the application
FROM node:16-alpine AS build

WORKDIR /app

# Copy and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application files and build
COPY . .
RUN npm run build

# Stage 2: NGINX to serve the built files
FROM nginx:alpine

# Copy the built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy a custom NGINX configuration file (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to the host
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
