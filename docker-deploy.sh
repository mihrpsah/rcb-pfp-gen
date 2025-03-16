#!/bin/bash

echo "Starting RCB Profile Picture Generator Docker Deployment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
mkdir -p backend/uploads backend/saved_models bg

# Check if background images exist
if [ ! "$(ls -A bg 2>/dev/null)" ]; then
    echo "Warning: No background images found in the bg directory."
    echo "Please add background images to the bg directory before running the application."
fi

# Build and start the containers
echo "Building and starting Docker containers..."
docker-compose up -d --build

echo "Deployment complete!"
echo "The application should be available at http://localhost"
echo "The backend API is available at http://localhost:5000"
echo ""
echo "To stop the application, run: docker-compose down"