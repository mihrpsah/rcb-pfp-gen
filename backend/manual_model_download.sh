#!/bin/bash

echo "Manual U2-Net Model Download Script"
echo "=================================="
echo

# Create the model directory if it doesn't exist
mkdir -p saved_models

# Check if the model already exists
if [ -f "saved_models/u2net.pth" ]; then
    echo "Model already exists at saved_models/u2net.pth"
    exit 0
fi

echo "Attempting to download U2-Net model..."

# Try multiple download sources
download_sources=(
    "https://github.com/xuebinqin/U-2-Net/releases/download/v1.0/u2net.pth"
    "https://huggingface.co/xuebinqin/U-2-Net/resolve/main/u2net.pth"
)

for source in "${download_sources[@]}"; do
    echo "Trying to download from: $source"
    
    if command -v curl &> /dev/null; then
        # Use curl if available
        curl -L "$source" -o saved_models/u2net.pth
    elif command -v wget &> /dev/null; then
        # Use wget if available
        wget "$source" -O saved_models/u2net.pth
    else
        echo "Error: Neither curl nor wget is available. Please install one of them and try again."
        exit 1
    fi
    
    # Check if download was successful
    if [ -f "saved_models/u2net.pth" ] && [ -s "saved_models/u2net.pth" ]; then
        echo "Model downloaded successfully to saved_models/u2net.pth"
        exit 0
    else
        echo "Download failed. Trying next source..."
    fi
done

echo "All download attempts failed."
echo "Please download the model manually from one of these sources:"
for source in "${download_sources[@]}"; do
    echo "- $source"
done
echo "Then place it in the saved_models directory as u2net.pth"

exit 1 