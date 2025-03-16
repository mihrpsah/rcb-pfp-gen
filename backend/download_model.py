import os
import gdown
import torch
import requests
from pathlib import Path
import time

def download_u2net_model():
    """
    Downloads the U2-Net model if it doesn't exist.
    Uses multiple fallback methods if the primary download fails.
    """
    print("Checking for U2-Net model...")
    
    # Create the model directory if it doesn't exist
    model_dir = Path("saved_models")
    model_dir.mkdir(exist_ok=True)
    
    # Path to the model file
    model_path = model_dir / "u2net.pth"
    
    # Check if the model already exists
    if model_path.exists():
        print(f"Model already exists at {model_path}")
        return True
    
    # Try multiple download methods
    download_methods = [
        download_with_gdown,
        download_with_direct_link,
        download_with_huggingface
    ]
    
    for method in download_methods:
        print(f"Attempting download using {method.__name__}...")
        success = method(model_path)
        if success:
            # Verify the model
            if verify_model(model_path):
                print("Model downloaded and verified successfully!")
                return True
            else:
                print("Model verification failed. Trying next method...")
                # Remove potentially corrupted file
                if model_path.exists():
                    os.remove(model_path)
        
        # Wait a bit before trying the next method
        time.sleep(1)
    
    print("All download methods failed. Please download the model manually.")
    print("1. Download from: https://github.com/xuebinqin/U-2-Net/releases/download/v1.0/u2net.pth")
    print(f"2. Place it in the {model_dir} directory")
    return False

def download_with_gdown(model_path):
    """Download using gdown from Google Drive."""
    try:
        # Google Drive ID for the U2-Net model
        u2net_model_id = "1tCU5MM1LhRgGou5OpmpjBQbSrYIUoYab"
        
        print(f"Downloading U2-Net model from Google Drive to {model_path}...")
        gdown.download(id=u2net_model_id, output=str(model_path), quiet=False)
        return model_path.exists()
    except Exception as e:
        print(f"Error downloading with gdown: {e}")
        return False

def download_with_direct_link(model_path):
    """Download from a direct link."""
    try:
        # Direct link to the model
        url = "https://github.com/xuebinqin/U-2-Net/releases/download/v1.0/u2net.pth"
        
        print(f"Downloading U2-Net model from direct link to {model_path}...")
        response = requests.get(url, stream=True)
        response.raise_for_status()
        
        with open(model_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        return model_path.exists()
    except Exception as e:
        print(f"Error downloading from direct link: {e}")
        return False

def download_with_huggingface(model_path):
    """Download from Hugging Face."""
    try:
        # Hugging Face model URL
        url = "https://huggingface.co/xuebinqin/U-2-Net/resolve/main/u2net.pth"
        
        print(f"Downloading U2-Net model from Hugging Face to {model_path}...")
        response = requests.get(url, stream=True)
        response.raise_for_status()
        
        with open(model_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        return model_path.exists()
    except Exception as e:
        print(f"Error downloading from Hugging Face: {e}")
        return False

def verify_model(model_path):
    """Verify the model can be loaded."""
    try:
        # Try to load the model to verify it's valid
        model = torch.load(model_path, map_location=torch.device('cpu'))
        print("Model verified successfully!")
        return True
    except Exception as e:
        print(f"Error verifying model: {e}")
        return False

if __name__ == "__main__":
    success = download_u2net_model()
    if success:
        print("U2-Net model is ready to use!")
    else:
        print("Failed to download U2-Net model. Please follow the manual download instructions above.")