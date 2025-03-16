#!/bin/bash

echo "RCB Profile Picture Generator - Render Deployment Helper"
echo "====================================================="
echo

# Check if the model exists
if [ ! -f "saved_models/u2net.pth" ]; then
    echo "U2-Net model not found. Attempting to download..."
    
    # Try Python script first
    python download_model.py
    
    # If that fails, try manual download
    if [ ! -f "saved_models/u2net.pth" ]; then
        echo "Python download failed. Trying manual download..."
        ./manual_model_download.sh
    fi
    
    # Check if download was successful
    if [ -f "saved_models/u2net.pth" ]; then
        echo "✅ Model downloaded successfully!"
    else
        echo "❌ Model download failed. You'll need to download it manually after deployment."
    fi
else
    echo "✅ U2-Net model already exists."
fi

# Create necessary directories
mkdir -p uploads bg

# Check for background images
if [ ! "$(ls -A bg 2>/dev/null)" ]; then
    echo "⚠️ Warning: No background images found in the bg directory."
    echo "   You'll need to upload background images after deployment."
else
    echo "✅ Background images found in bg directory."
fi

# Create a Render-specific .env file
echo "Creating Render environment file..."
cat > .env.render << EOL
DEBUG=False
PORT=\$PORT
UPLOAD_FOLDER=uploads
BG_FOLDER=bg
MODEL_DIR=saved_models
EOL
echo "✅ Created .env.render file"

echo
echo "Render Deployment Instructions:"
echo "==============================="
echo "1. Create a new Web Service on Render (https://dashboard.render.com/)"
echo "2. Connect your GitHub repository"
echo "3. Configure the service:"
echo "   - Environment: Python 3"
echo "   - Build Command: pip install -r requirements.txt && python download_model.py"
echo "   - Start Command: gunicorn app:app"
echo "4. Add the following environment variables:"
echo "   - DEBUG: False"
echo "   - UPLOAD_FOLDER: uploads"
echo "   - BG_FOLDER: bg"
echo "   - MODEL_DIR: saved_models"
echo "5. Deploy the service"
echo
echo "After deployment:"
echo "1. If the model download failed during deployment, use the Render Shell to run:"
echo "   ./manual_model_download.sh"
echo "2. Upload background images using the Render Shell or Disk feature"
echo "3. Update your frontend .env.production with the Render URL"
echo
echo "For more detailed instructions, see the Render deployment section in DEPLOYMENT.md" 