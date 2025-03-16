#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Check if Python virtual environment exists, if not create it
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Create placeholder logo files if they don't exist
mkdir -p frontend/public
if [ ! -f "frontend/public/logo192.png" ]; then
    echo "Creating placeholder logo files..."
    # Create a simple 192x192 transparent PNG
    convert -size 192x192 xc:transparent frontend/public/logo192.png 2>/dev/null || echo "Warning: Could not create logo192.png (ImageMagick not installed)"
fi

if [ ! -f "frontend/public/logo512.png" ]; then
    # Create a simple 512x512 transparent PNG
    convert -size 512x512 xc:transparent frontend/public/logo512.png 2>/dev/null || echo "Warning: Could not create logo512.png (ImageMagick not installed)"
fi

if [ ! -f "frontend/public/favicon.ico" ]; then
    # Copy a default favicon or create a simple one
    cp -f bg/RCB\ logo\ 2024.jpg frontend/public/favicon.ico 2>/dev/null || echo "Warning: Could not create favicon.ico"
fi

# Download U2-Net model if not exists
if [ ! -f "backend/saved_models/u2net.pth" ]; then
    echo "Downloading U2-Net model..."
    cd backend
    python download_model.py
    cd ..
fi

# Start backend server in the background
echo "Starting backend server..."
cd backend
python app.py &
BACKEND_PID=$!
cd ..

# Wait for backend to start
echo "Waiting for backend to start..."
sleep 5

# Check if backend is running
if ! ps -p $BACKEND_PID > /dev/null; then
    echo "Error: Backend failed to start. Check logs for details."
    exit 1
fi

# Install frontend dependencies if node_modules doesn't exist
if [ ! -d "frontend/node_modules" ]; then
    echo "Installing frontend dependencies..."
    cd frontend
    npm install
    cd ..
fi

# Start frontend server
echo "Starting frontend server..."
cd frontend
npm start &
FRONTEND_PID=$!
cd ..

# Function to handle script termination
function cleanup {
    echo "Shutting down servers..."
    kill $BACKEND_PID 2>/dev/null || echo "Backend already stopped"
    kill $FRONTEND_PID 2>/dev/null || echo "Frontend already stopped"
    exit
}

# Register the cleanup function for when script receives SIGINT
trap cleanup SIGINT

# Keep the script running
echo "Servers are running. Press Ctrl+C to stop."
wait 