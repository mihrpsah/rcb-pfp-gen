#!/bin/bash

# Download the U2-Net model if it doesn't exist
if [ ! -f "saved_models/u2net.pth" ]; then
    echo "Downloading U2-Net model..."
    python download_model.py
    
    # Check if the download was successful
    if [ ! -f "saved_models/u2net.pth" ]; then
        echo "Automatic download failed. Trying manual download script..."
        ./manual_model_download.sh
        
        # Check if manual download was successful
        if [ ! -f "saved_models/u2net.pth" ]; then
            echo "Manual download also failed. Please download the model manually and place it in saved_models/u2net.pth"
            echo "You can download it from: https://github.com/xuebinqin/U-2-Net/releases/download/v1.0/u2net.pth"
        fi
    fi
fi

# Create a production .env file
echo "Creating production .env file..."
cat > .env.prod << EOL
DEBUG=False
PORT=\$PORT
UPLOAD_FOLDER=uploads
BG_FOLDER=bg
MODEL_DIR=saved_models
EOL

echo "Backend deployment preparation completed!"
echo "You can now deploy this directory to a platform like Heroku, Railway, or Render."
echo "Make sure to set up the bg directory with your background images on the server."

# Render-specific instructions
echo ""
echo "For Render deployment:"
echo "1. Create a new Web Service on Render"
echo "2. Connect your GitHub repository"
echo "3. Set the build command: pip install -r requirements.txt && python download_model.py"
echo "4. Set the start command: gunicorn app:app"
echo "5. Add the environment variables listed in .env.prod"
echo "6. If model download fails during deployment, use the Shell tab to run ./manual_model_download.sh" 