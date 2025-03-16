#!/bin/bash

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Go to backend directory
cd backend

# Start the Flask server
echo "Starting backend server..."
python app.py

# This script will keep running until you press Ctrl+C 