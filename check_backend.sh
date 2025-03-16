#!/bin/bash

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install it to run this script."
    exit 1
fi

# Try to connect to the backend
echo "Checking if backend is running..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/api/backgrounds)

if [ "$response" = "200" ]; then
    echo "✅ Backend is running correctly and returning backgrounds!"
else
    echo "❌ Backend is not responding correctly. Status code: $response"
    echo "Make sure the backend server is running with ./start_backend.sh"
fi 