# Stage 1: Build
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn install

# Copy the rest of the application
COPY . .

# Build the application
RUN yarn run build

# Stage 2: Production
FROM nginx:alpine

# Copy build output to Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port Nginx runs on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
