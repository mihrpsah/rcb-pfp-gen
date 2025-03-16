import os
import gdown
import torch
from pathlib import Path

def download_u2net_model():
    """
    Downloads the U2-Net model if it doesn't exist.
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
        return
    
    # Google Drive ID for the U2-Net model
    u2net_model_id = "1tCU5MM1LhRgGou5OpmpjBQbSrYIUoYab"
    
    print(f"Downloading U2-Net model to {model_path}...")
    try:
        gdown.download(id=u2net_model_id, output=str(model_path), quiet=False)
        print("Model downloaded successfully!")
        
        # Verify the model can be loaded
        try:
            # Try to load the model to verify it's valid
            model = torch.load(model_path, map_location=torch.device('cpu'))
            print("Model verified successfully!")
        except Exception as e:
            print(f"Error verifying model: {e}")
            # If verification fails, delete the potentially corrupted file
            if model_path.exists():
                os.remove(model_path)
            print("Corrupted model file removed. Please try downloading again.")
            return False
        
        return True
    except Exception as e:
        print(f"Error downloading model: {e}")
        return False

if __name__ == "__main__":
    success = download_u2net_model()
    if success:
        print("U2-Net model is ready to use!")
    else:
        print("Failed to download U2-Net model. Please check your internet connection and try again.")