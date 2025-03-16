#!/bin/bash

# Download the U2-Net model if it doesn't exist
if [ ! -f "saved_models/u2net.pth" ]; then
    echo "Downloading U2-Net model..."
    python download_model.py
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