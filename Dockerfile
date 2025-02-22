# Use the official Node.js 18 image as the base image
FROM node:18.0.0

# Set the working directory inside the container to /app
WORKDIR /app

# Copy package.json and yarn.lock files to the working directory
COPY package.json yarn.lock ./

# Install project dependencies specified in package.json
RUN yarn install

# Copy all files from the current directory to the container's working directory
COPY . .

# Build the application for production
RUN yarn build

# Install 'serve' globally to serve the built application
RUN yarn global add serve

# Expose port 3000 to allow external access
EXPOSE 3000

# Command to serve the built application on port 3000
CMD ["serve", "-s", "build", "--listen", "tcp://0.0.0.0:3000"]


