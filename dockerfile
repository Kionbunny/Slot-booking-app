# Stage 1: Build the React app
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the React app
RUN npm run build

# ------------------------------------------------------

# Stage 2: Serve the app with Nginx
FROM nginx:stable-alpine

# Set working directory inside nginx
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy built React app from previous stage
COPY --from=build /app/build .

# Expose port 80
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
